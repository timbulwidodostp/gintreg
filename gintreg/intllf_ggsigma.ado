/*This ado file gives the log likelihood function used in interval regressions
for the GG distribution. It uses the delta-sigma parameterization.
For use with group data.
It works with gintreg.ado
v 1
Author--Jacob Orchard
Update--8/8/2016*/

program intllf_ggsigma
version 13
		args lnf delta sigma p  
		tempvar Fu Fl zu zl 
		qui gen double `Fu' = .
		qui gen double `Fl' = .
		qui gen double `zu' = . 
		qui gen double `zl' = .
		
		*Point data
		tempvar x y z w v
		qui gen double `x' = `p'*((log($ML_y1) - `delta')/exp(`sigma') ) ///
							if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
							
		qui gen double `y' = log(exp(`sigma')) if $ML_y1 != . & $ML_y2 != . & ///
								$ML_y1 == $ML_y2
								
		qui gen double `z' = log($ML_y1) if $ML_y1 != . & $ML_y2 != . & ///
								$ML_y1 == $ML_y2
								
		qui gen double `w' = lngamma(`p') if $ML_y1 != . & $ML_y2 != . & $ML_y1 == $ML_y2
		
		qui gen double `v' = exp((log($ML_y1 )-`delta')/exp(`sigma')) if $ML_y1 != .  ///
								& $ML_y2 != . & $ML_y1 == $ML_y2
								
		qui replace `lnf' = `x' - `y' - `z' - `w' - `v'
			
		*Interval data
		qui replace `zu' = ($ML_y2/exp(`delta'))^(1/exp(`sigma')) if $ML_y1 != . & $ML_y2 != . & ///
														$ML_y1 != $ML_y2
							
		qui replace `Fu' = gammap(`p',`zu') if $ML_y1 != . & $ML_y2 != . ///
							&  $ML_y1 != $ML_y2
							
		qui replace `zl' = ($ML_y1/exp(`delta'))^(1/exp(`sigma')) if $ML_y1 != . & $ML_y2 != .  ///
											&  $ML_y1 != $ML_y2
							
		qui replace `Fl' = gammap(`p',`zl') if $ML_y1 != . & $ML_y2 != . ///
									&  $ML_y1 != $ML_y2
									
		qui replace `lnf' = log(`Fu' -`Fl') if $ML_y1 != . & $ML_y2 != . ///
							&  $ML_y1 != $ML_y2
		
		
		*Bottom coded data
		qui replace `zl' = ($ML_y1/exp(`delta'))^(1/exp(`sigma')) if $ML_y1 != . & $ML_y2 == .
								
		qui replace `Fl' = gammap(`p',`zl') if $ML_y1 != . & $ML_y2 == .
						
		qui replace `lnf' = log(1-`Fl') if $ML_y1 != . & $ML_y2 == .
		
		*Top coded data
		qui replace `zu' = ($ML_y2/exp(`delta'))^(1/exp(`sigma'))	if $ML_y2 != . & $ML_y1 == .
							
		qui replace `Fu' = gammap(`p',`zu') if $ML_y2 != . & $ML_y1 == .
								
		qui replace `lnf' = log(`Fu') if $ML_y2 != . & $ML_y1 == .
			
		*Missing values
		qui replace `lnf' = 0 if $ML_y2 == . & $ML_y1 == .	
end		
