#!/bin/bash

template="flash.par"


#!/bin/bash

# Array of unique values for each parameter
alphaL_values=(0.1 0.2 0.4 0.8 1.6)
Deint_values=(0.001 0.002 0.005 0.01 0.02)
Detrb_values=(0.042 0.083 0.17 0.33 0.67)

# Loop over each combination of parameter values
for alphaL in "${alphaL_values[@]}"; do
    for Deint in "${Deint_values[@]}"; do
        for Detrb in "${Detrb_values[@]}"; do
            # Generate the new file name
            new_file="flash_${alphaL}_${Deint}_${Detrb}.par"
            cp "$template" "$new_file"
            sed -i "s/stir_mesa20_diss_aL0p75_a0p005_aEt0p33_/stir_mesa20_${alphaL}_${Deint}_${Detrb}_/g" "$new_file"
            sed -i "s/mlt_alphaL = 0.75/mlt_alphaL = $alphaL/g" "$new_file"
            sed -i "s/mlt_Deint = 0.005/mlt_Deint = $Deint/g" "$new_file"
            sed -i "s/mlt_Dye = 0.005/mlt_Dye = $Deint/g" "$new_file"
            sed -i "s/mlt_Dneut = 0.005/mlt_Dneut = $Deint/g" "$new_file"
            sed -i "s/mlt_Detrb = 0.3333/mlt_Detrb = $Detrb/g" "$new_file"
            cp submitjob.sb submitjob0.sb
            sed -i "s/flash4_mlt/flash4_mlt -par_file $new_file/g" submitjob0.sb
            sbatch submitjob0.sb
        done
    done
done


echo "New files created successfully."

