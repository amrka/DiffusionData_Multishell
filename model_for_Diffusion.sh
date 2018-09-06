#!/bin/bash
#Created by Amr:Thu Aug 30 10:56:18 CEST 2018
#This script desribes the process of creating a model for diffusion and labels
#First I moved the VBM_template_manual_ext and fslswapdim

# fslswapdim VBM_manul_ext.nii.gz LR IS AP VBM
# fslorient -deleteorient VBM 
# fslorient -setsformcode 1 VBM

#Now I am downloading the ambmc model and all attached labels, the symmetric one: it says on the website
# The model is available in both nonsymmetric and symmetric versions. 
# Note that all the segmentations that are released as defined on the symmetric model for the purposes of model based segmentation. 
# For most intents and purposes you should use the symmetric version of the model, 
# we have included the nonsymmetric version for people who are interested in left-right average differences. 
# If you plan to do volume comparisons of structures left/right via model based segmentation you should be fitting 
# to a symmetric model to avoid left/right bias. 


#I downloaded:

# 1 -> symmetric model 
# 2 -> Basal Ganglia
# 3 -> Cerebellum
# 4 -> Cortex
# 5 -> Hippocampus
# 6 -> Diancephalon

cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc

# for file in *.tar.gz;do
# 	tar -xzf $file
# done

#---------------------------------------------------------------------
#Now you Augment all the files after decompression

cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc

# for folder in *;do
# 	if [ -d $folder ]; then
# 		cd $folder
# 		pwd
# 		Augment.sh *.nii 10

#   		cd ..	
# 	fi

# done

#---------------------------------------------------------------------
#We downsample 3 folds using resize_img.m from spm in matlab

# Vox dim :     [0.75 0.75 .75]
# Bounding Box: nan(2,3)

#---------------------------------------------------------------------
#Swapdim to match the diff data and the VBM template

cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc

# for folder in *;do
# 	if [ -d $folder ]; then
# 		cd $folder
# 		pwd
# 		file=r*.nii
# 		echo $file
# 		name=`echo $file | sed s/rambmc-c57bl6-/''/ | sed s/_v0.8.nii/''/` #keep the name only after swapdim
# 		echo $name
# 		fslswapdim $file LR IS AP $name
# 		fslorient -deleteorient   $name
# 		fslorient -setsformcode 1 $name

#   		cd ..	
# 	fi

# done


#---------------------------------------------------------------------
#Now, I register the model (model-sym now) to my vbm template
cd /media/amr/Amr_4TB/Probtackx_Trial

# antsRegistrationSyN.sh \
# -d 3 \
# -f '/media/amr/Amr_4TB/Probtackx_Trial/VBM.nii.gz' \
# -m '/media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc/ambmc-c57bl6-model-symmet_v0.8-nii/model-symmet.nii.gz' \
# -o 'ambmc_model_to_VBM_template_' \
# -n 8 \
# -x '/media/amr/Amr_4TB/Probtackx_Trial/VBM_Mask.nii.gz' \

#I used spyder_antsregistration.py though for the composite transformations

# import os

# import nipype.interfaces.ants as ants
# import nipype.interfaces.fsl as fsl
# os.chdir('/media/amr/Amr_4TB/Probtackx_Trial/')

# antsRegistrationSyN = ants.Registration()
# antsRegistrationSyN.inputs.args='--float'
# antsRegistrationSyN.inputs.collapse_output_transforms=True
# antsRegistrationSyN.inputs.fixed_image= '/media/amr/Amr_4TB/Probtackx_Trial/VBM.nii.gz' 
# #antsRegistrationSyN.inputs.fixed_image_mask = '/media/amr/Amr_4TB/Probtackx_Trial/VBM_Mask.nii.gz'
# antsRegistrationSyN.inputs.moving_image= '/media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc/ambmc-c57bl6-model-symmet_v0.8-nii/model-symmet.nii.gz'
# antsRegistrationSyN.inputs.initial_moving_transform_com=True
# antsRegistrationSyN.inputs.num_threads=8
# antsRegistrationSyN.inputs.output_inverse_warped_image=True
# antsRegistrationSyN.inputs.output_warped_image=True
# antsRegistrationSyN.inputs.sigma_units=['vox']*3
# antsRegistrationSyN.inputs.transforms= ['Rigid', 'Affine', 'SyN']
# antsRegistrationSyN.inputs.winsorize_lower_quantile=0.005
# antsRegistrationSyN.inputs.winsorize_upper_quantile=0.995
# antsRegistrationSyN.inputs.convergence_threshold=[1e-06]
# antsRegistrationSyN.inputs.convergence_window_size=[10]
# antsRegistrationSyN.inputs.metric=['MI', 'MI', 'CC']
# antsRegistrationSyN.inputs.metric_weight=[1.0]*3
# antsRegistrationSyN.inputs.number_of_iterations=[[1000, 500, 250, 100],
#                                                  [1000, 500, 250, 100],
#                                                  [100, 70, 50, 20]]
# antsRegistrationSyN.inputs.radius_or_number_of_bins=[32, 32, 4]
# antsRegistrationSyN.inputs.sampling_percentage=[0.25, 0.25, 1]
# antsRegistrationSyN.inputs.sampling_strategy=['Regular',
#                                               'Regular',
#                                               'None']
# antsRegistrationSyN.inputs.shrink_factors=[[8, 4, 2, 1]]*3
# antsRegistrationSyN.inputs.smoothing_sigmas=[[3, 2, 1, 0]]*3
# antsRegistrationSyN.inputs.transform_parameters=[(0.1,),
#                                                  (0.1,),
#                                                  (0.1, 3.0, 0.0)]
# antsRegistrationSyN.inputs.use_histogram_matching=True
# antsRegistrationSyN.inputs.write_composite_transform=True
# antsRegistrationSyN.inputs.verbose=True
# antsRegistrationSyN.inputs.output_warped_image=True
# antsRegistrationSyN.inputs.float=True
# antsRegistrationSyN.inputs.output_transform_prefix = 'ambmc_model_to_VBM_template_'


# antsRegistrationSyN.run()

#---------------------------------------------------------------------
# apply the transormations to all the other labels to move them to VBM space

# cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc

# ambmc_to_VBM_transform='/media/amr/Amr_4TB/Probtackx_Trial/ambmc_model_to_VBM_template_Composite.h5'

# for folder in *;do
# 	if [ -d $folder ]; then
# 		cd $folder
# 		pwd
# 		file=r*.nii
# 		echo $file
# 		name=`echo $file | sed s/rambmc-c57bl6-/''/ | sed s/_v0.8.nii/''/` #just to get the names
# 		echo $name
# 		#Apply transformation to bring the labels to VBM space
		
# 		antsApplyTransforms \
# 		-d 3 \
# 		-i ${name}.nii.gz \
# 		-r '/media/amr/Amr_4TB/Probtackx_Trial/VBM.nii.gz' \
# 		-o ${name}_to_VBM.nii.gz \
# 		-n NearestNeighbor \
# 		-t ${ambmc_to_VBM_transform} \
# 		-v


#   		cd ..	
# 	fi

# done

#The cerebellum did not work, it has different dimensions slice wise than the rest

#---------------------------------------------------------------------
#Seperate right hemisphere from left hemispheres across the midline

# cd /media/amr/Amr_4TB/Probtackx_Trial

# fslroi VBM.nii.gz half_VBM 0 55 0 -1  0 -1
# fslroi VBM.nii.gz other_half_VBM 54 55 0 -1  0 -1

#I made sure they are 100 % symmetric by overlaying both of them with different colors on top of the VBM model using mricron

#---------------------------------------------------------------------
#Seperate right from left 

# cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc

# ambmc_to_VBM_transform='/media/amr/Amr_4TB/Probtackx_Trial/ambmc_model_to_VBM_template_Composite.h5'

# for folder in *;do
# 	if [ -d $folder ]; then
# 		cd $folder
# 		label=`echo $folder | sed s/ambmc-c57bl6-/''/ | sed s/_v0.8.nii/''/` #just to get the names
# 		pwd
# 		echo $label
	
# 		img=${label}_to_VBM.nii.gz
# 		echo $img

# 		fslroi $img Right_${label}_to_VBM 0 55 0 -1  0 -1
# 		fslroi $img Left_${label}_to_VBM 54 55 0 -1  0 -1



		

#   		cd ..	
# 	fi

# done

#---------------------------------------------------------------------
#Make some interesting ROIs
#Strating with hippocampus
#I checked multiple times using images histogram that the -uthr and -thr are accurately capturing the correct labels


# cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc/ambmc-c57bl6-label-hippocampus_v0.8-nii

# fslmaths Right_label-hippocampus_to_VBM  -uthr 4 -bin R_CA1_to_VBM
# fslmaths  Left_label-hippocampus_to_VBM  -uthr 4 -bin L_CA1_to_VBM

# fslmaths Right_label-hippocampus_to_VBM -thr 5 -uthr 7 -bin R_CA2_to_VBM
# fslmaths  Left_label-hippocampus_to_VBM -thr 5 -uthr 7 -bin L_CA2_to_VBM

# fslmaths Right_label-hippocampus_to_VBM -thr 8 -uthr 11 -bin R_CA3_to_VBM
# fslmaths  Left_label-hippocampus_to_VBM -thr 8 -uthr 11 -bin L_CA3_to_VBM


# fslmaths Right_label-hippocampus_to_VBM -thr 13  -bin R_DG_to_VBM
# fslmaths  Left_label-hippocampus_to_VBM -thr 13  -bin L_DG_to_VBM


# fslmaths Right_label-hippocampus_to_VBM -uthr 12 -thr 12  -bin R_Stratum_to_VBM
# fslmaths  Left_label-hippocampus_to_VBM -uthr 12 -thr 12  -bin L_Stratum_to_VBM


#---------------------------------------------------------------------
#Go for the basal ganglia
#Only a finite things 

# cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc/ambmc-c57bl6-label-basalganglia_v0.8-nii


# fslmaths Right_label-basalganglia_to_VBM -uthr 9 -thr 9  -bin R_Caudate_putamen_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 9 -thr 9  -bin L_Caudate_putamen_to_VBM


# fslmaths Right_label-basalganglia_to_VBM -uthr 7 -thr 7  -bin R_Corpus_Callosum_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 7 -thr 7  -bin L_Corpus_Callosum_to_VBM


# fslmaths Right_label-basalganglia_to_VBM -thr 2 -uthr 3  -bin R_Accumbens_nucleus_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -thr 2 -uthr 3  -bin L_Accumbens_nucleus_to_VBM


# fslmaths Right_label-basalganglia_to_VBM -uthr 16 -thr 16  -bin R_Internal_capsule_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 16 -thr 16  -bin L_Internal_capsule_to_VBM

# fslmaths Right_label-basalganglia_to_VBM -uthr 12 -thr 12  -bin R_Fornix_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 12 -thr 12  -bin L_Fornix_to_VBM

# fslmaths Right_label-basalganglia_to_VBM -uthr 14 -thr 14  -bin R_Globus_pallidus_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 14 -thr 14  -bin L_Globus_pallidus_to_VBM

# fslmaths Right_label-basalganglia_to_VBM -uthr 21 -thr 21  -bin R_Lateral_hypothalamus_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 21 -thr 21  -bin L_Lateral_hypothalamus_to_VBM


# fslmaths Right_label-basalganglia_to_VBM -uthr 6 -thr 6  -bin R_Basal_nucleus_to_VBM
# fslmaths  Left_label-basalganglia_to_VBM -uthr 6 -thr 6  -bin L_Basal_nucleus_to_VBM

#---------------------------------------------------------------------
#Go for cortex

# cd /media/amr/Amr_4TB/Probtackx_Trial/Model_for_Diffusion_ambmc/ambmc-c57bl6-label-cortex_v0.8-nii

# fslmaths Right_label-cortex_to_VBM -uthr 10  -bin R_Cingulate_cortex_to_VBM
# fslmaths  Left_label-cortex_to_VBM -uthr 10  -bin L_Cingulate_cortex_to_VBM

#---------------------------------------------------------------------
#copy all seeds to a new folder called /media/amr/Amr_4TB/Probtackx_Trial/Seeds
#transform all of the sseds to 242 example subject space 
mkdir /media/amr/Amr_4TB/Probtackx_Trial/Seeds_242

cd /media/amr/Amr_4TB/Probtackx_Trial/Seeds



for seed in *;do
	seed=`remove_ext $seed`
	antsApplyTransforms \
	-d 3 \
	-i ${seed}.nii.gz \
	-r /media/amr/Amr_4TB/Probtackx_Trial/242/b0.nii.gz \
	-o /media/amr/Amr_4TB/Probtackx_Trial/Seeds_242/${seed}_242.nii.gz \
	-n NearestNeighbor \
	-t /media/amr/Amr_4TB/Probtackx_Trial/242/transformInverseComposite.h5
done

#create text file with all the seeds
cd /media/amr/Amr_4TB/Probtackx_Trial/Seeds_242


ls -d -1 $PWD/** > Seeds_242.txt 



