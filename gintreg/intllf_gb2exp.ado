program intllf_gb2exp
version 13
	args lnf delta sigma p q
	tempvar Fu Fl zu zl xu xl
	qui gen double `Fu' = .
	qui gen double `Fl' = .
	qui gen double `zu' = . 
	qui gen double `zl' = .
	qui gen double `xu' = . 
	qui gen double `xl' = . 
	
	*Point data
	tempvar x y z w v
	
	qui gen double `x' = `p'*((log($ML_y1) - `delta')/exp(`sigma')) ///
						if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
						
	qui gen double `y' = log(exp(`sigma')) ///
						if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
						
	qui gen double `z' = log($ML_y1) if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
	
	qui gen double `w' = lngamma(`p') + lngamma(`q') - lngamma(`p' + `q') ///
						if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
						
	qui gen double `v' = (`p'+`q')*log(1+ exp(((log($ML_y1)-`delta')/exp(`sigma')))) ///
						if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
						
	qui replace `lnf' = `x' - `y' - `z' - `w' - `v' if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
		
			
	*Interval data
	qui replace `xu' = log($ML_y2 ) - `delta' if $ML_y1 != . & $ML_y2 != . &  $ML_y1 != $ML_y2
	
	qui replace `zu' = exp(`xu' / exp(`sigma')) / (1 + exp(`xu' / exp(`sigma'))) if $ML_y1 != . & $ML_y2 != . &  $ML_y1 != $ML_y2
						
	qui replace `Fu' = 	ibeta(`p',`q',`zu') if $ML_y1 != . & $ML_y2 != . ///
						&  $ML_y1 != $ML_y2
	
	qui replace `xl' = log($ML_y1) - `delta' if $ML_y1 != . & $ML_y2 != . &  $ML_y1 != $ML_y2
						
	qui replace `zl' = exp(`xl' / exp(`sigma')) / (1 + exp(`xl' / exp(`sigma'))) if $ML_y1 != . & $ML_y2 != . &  $ML_y1 != $ML_y2
						
	qui replace `Fl' = 	ibeta(`p',`q',`zl') if $ML_y1 != . & $ML_y2 != . ///
								&  $ML_y1 != $ML_y2
								
	qui replace `lnf' = log(`Fu' -`Fl') if $ML_y1 != . & $ML_y2 != . ///
						&  $ML_y1 != $ML_y2

	*Bottom coded data
	qui replace `xl' = log($ML_y1 ) - `delta' if $ML_y1 != . & $ML_y2 == .

	qui replace `zl' = exp(`xl' / exp(`sigma')) / (1 + exp(`xl' / exp(`sigma'))) if $ML_y1 != . & $ML_y2 == .
							
	qui replace `Fl' = ibeta(`p',`q',`zl') if $ML_y1 != . & $ML_y2 == .
					
	qui replace `lnf' = log(1-`Fl') if $ML_y1 != . & $ML_y2 == .

	*Top coded data
	qui replace `xu' = log($ML_y2 ) - `delta' if $ML_y2 != . & $ML_y1 == .
						
	qui replace `zu' = exp(`xu' / exp(`sigma')) / (1 + exp(`xu' / exp(`sigma'))) if $ML_y2 != . & $ML_y1 == .
						
	qui replace `Fu' = ibeta(`p',`q',`zu') if $ML_y2 != . & ///
							$ML_y1 == .
							
	qui replace `lnf' = log(`Fu') if $ML_y2 != . & $ML_y1 == .
	
	*Missing values
	qui replace `lnf' = 0 if $ML_y2 == . & $ML_y1 == .
end
