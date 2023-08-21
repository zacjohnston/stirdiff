#!/bin/bash

template="template.par"


#!/bin/bash

# Array of unique values for each parameter
alphaL_values=(1.0 1.25)
Deint_values=(0.001 0.002 0.004)
Dye_values=(0.001)
Dneut_values=(0.001)
Detrb_values=(0.08 0.17 0.33)
alphaV_values=(0.67 1.0 1.33)

# Loop over each combination of parameter values
for alphaL in "${alphaL_values[@]}"; do
    for Deint in "${Deint_values[@]}"; do
        for Detrb in "${Detrb_values[@]}"; do
            for Dye in "${Dye_values[@]}"; do
                for Dneut in "${Dneut_values[@]}"; do
                    for alphaV in "${alphaV_values[@]}"; do
                        Dye=${Deint}
                        Dneut=${Deint}
                        # Generate the new file name
                        new_file="flash_${alphaL}_${alphaV}_${Detrb}_${Deint}_${Dye}_${Dneut}.par"
                        cp "$template" "$new_file"
                        sed -i "s/fitStir_mesa20_/fitStir_${alphaL}_${alphaV}_${Detrb}_${Deint}_${Dye}_${Dneut}_/g" "$new_file"
                        sed -i "s/mlt_alphaL = 0.75/mlt_alphaL = $alphaL/g" "$new_file"
                        sed -i "s/mlt_Deint = 0.005/mlt_Deint = $Deint/g" "$new_file"
                        sed -i "s/mlt_Dye = 0.005/mlt_Dye = $Dye/g" "$new_file"
                        sed -i "s/mlt_Dneut = 0.005/mlt_Dneut = $Dneut/g" "$new_file"
                        sed -i "s/mlt_Detrb = 0.3333/mlt_Detrb = $Detrb/g" "$new_file"
                        sed -i "s/mlt_alphaV = 1.0/mlt_alphaV = $alphaV/g" "$new_file"
                        cp submitjob.sb submitjob0.sb
                        sed -i "s/flash4_mlt/flash4_mlt -par_file $new_file/g" submitjob0.sb
                        sbatch submitjob0.sb
                    done
                done
            done
        done
    done
done


echo "New files created successfully."

