# Score Normalization for Demographic Fairness in Face Recognition
This repository contains the implementation of score normalization methods mentioned in the paper. The pipeline supports various methods for score normalization based on demographic information.


## Abstract
Fair biometric algorithms have similar verification performance across different demographic groups given a single decision threshold. Unfortunately, for state-of-the-art face recognition networks, score distributions differ between demographics. Contrary to work that tries to align those distributions by extra training or fine-tuning, we solely focus on score post-processing methods. As proved, well-known sample-centered score normalization techniques, Z-norm and T-norm, do not improve fairness for high-security operating points. Thus, we extend the standard Z/T-norm to integrate demographic information in normalization. Additionally, we investigate several possibilities to incorporate cohort similarities for both genuine and impostor pairs per demographic to improve fairness across different operating points. We run experiments on two datasets with different demographics (gender and ethnicity) and show that our techniques generally improve the overall fairness of five state-of-the-art pre-trained face recognition networks, without downgrading verification performance. We also indicate that an equal contribution of False Match Rate (FMR) and False Non-Match Rate (FNMR) in fairness evaluation is required for the highest gains.


## Table of Contents
- [Installation](#installation)
- [Dataset](#dataset)
- [Usage](#usage)
- [Supplemental](#supplemental)
- [License](#license)


## Installation

```
$ git clone https://github.com/AIML-IfI/score-norm-fairness.git 
$ conda env create -f environment.yaml
$ conda activate score_normalization
$ cd score_norm_paper
```

## Datasets & Pretrained Weights

Download the protocols: https://seafile.ifi.uzh.ch/f/0fc877a36db84fdf9627/

Get access and download the datasets:
- RFW: http://www.whdeng.cn/RFW/index.html
- VGGFace2: https://github.com/ox-vgg/vgg_face2

Download the pretrained weights used in the paper:

| **Model** | **Network**   | **Training Data** | **Loss Function** |
|-----------|---------------|-------------------|-------------------|
| E1        | ResNet34      | CASIA-WebFace     | ArcFace           |
| E2        | ResNet50      | MS1M-w/o-RFW      | ArcFace           |
| E3        | IResNet100    | Webface12M        | AdaFace           |
| E4        | IResNet100    | MS1M              | MagFace           |
| E5        | IResNet100    | Webface12M        | DALIFace          |

- E1 & E2: http://www.whdeng.cn/RFW/model.html
- E3: https://github.com/mk-minchul/AdaFace
- E4: https://github.com/IrvingMeng/MagFace
- E5: DaliID: Distortion-adaptive learned invariance for identification – a robust technique for face recognition and person re-identification.

Besides, you can download the extracted features from https://seafile.ifi.uzh.ch/f/0fc877a36db84fdf9627/, which are used to generate the results shown in the paper.

## Usage
With the preassumption that you have the extracted features ready, we introduce the pipeline to compute the cosine similarity scores from extracted features, compute normalization statistics from cohort scores, and apply those statistics to normalize raw scores. 

You can directly download the features that we used, or extract features with your own pretrained networks.

To run the pipeline, execute the config_rfw.sh/config_vgg_gender.sh/config_vgg_race.sh script with the appropriate arguments. Each script takes several arguments that control the stages of the pipeline, the normalization methods, and other settings.

```
score_norm.py --stage [train,test] --methods METHODS --demo_name [race,gender] --dataset [rfw,vgg2] --protocol PROTOCOL --data_directory /path/to/data --protocol_directory /path/to/protocols --output_directory /path/to/output
```

Besides, it is possible to compute TMRs and generate WERM report from generated csv score files. The latter also includes the demographic-specific FMRs and FNMRs at all required thresholds.



### Arguments

The following command-line arguments are supported:

	•	--stage, -stg: A comma-separated list of stages. Possible choices: train, test. If train, generate raw scores and cohort scores; if test, use cohort scores to compute statistics to normalize raw scores. Default: train,test
	•	--methods, -m: A comma-separated list of score normalization methods to be applied. Possible choices: M1, M1.1, M1.2, M2, M2.1, M2.2, M3, M4, M5. Default: M1
	•	--demo_name, -demo: Specific demographic to be used for normalization. Possible choices: race, gender. Default: race
	•	--dataset, -d: Dataset to be used. Possible choices: rfw, vgg2. Default: rfw
	•	--protocol, -p: Specify the protocol for dataset. Possible choices for rfw: original, random; possible choices for vgg2: vgg2-short-demo, vgg2-full-demo Default: original
	•	--data_directory, -dr: Directory containing the dataset/images. Default: None (Must be provided by the user)
	•	--protocol_directory, -pr: Directory containing the protocols. Default: None (Must be provided by the user)
	•	--output_directory, -o: Directory for output files. All CSV scores files, including raw scores, cohort scores, and normalized scores, will be saved here. Default: None (Must be provided by the user)


### Example

Here are examples of how to run the pipeline:

```
score_norm.py --stage train,test --methods M1.1,M2.1,M3,M4,M5 --demo_name race --dataset rfw --protocol original --data_directory /path/to/data --protocol_directory /path/to/protocols --output_directory /path/to/output

score_norm.py --stage train,test --methods M1.1,M2.1,M3,M4,M5 --demo_name race --dataset vgg2 --protocol vgg2-short-demo --data_directory /path/to/data --protocol_directory /path/to/protocols --output_directory /path/to/output

score_norm.py --stage train,test --methods M1.1,M2.1,M3,M4,M5 --demo_name gender --dataset vgg2 --protocol vgg2-short-demo --data_directory /path/to/data --protocol_directory /path/to/protocols --output_directory /path/to/output
```

### Evaluation

```
# TMR
evaluation/TMR/calculate_tmr.py -dir /path/to/SCORES -t TITLES -nt NUM_OF_THRESHOLDS -o /path/to/output

# WERM
evaluation/WERM/werm_report.py -d rfw -dir /path/to/SCORES -t TITLES -o /path/to/output

```

## Supplemental

Here we show the supplemental results that are promised in the paper

### Stability of `random` protocol for RFW dataset

We compute TMR and WERM for all methods on five randomly generated protocols, and assess their standard deviations across the five splits. Here, we show the average of these values among all methods, as well as the maximum and minimum.

|       |              | E1    | E2    | E3    | E5    |
|-------|--------------|-------|-------|-------|-------|
| **TMR** | **Mean<sub>STD</sub>** | 1.700 | 1.009 | 0.107 | 0.266 |
|       | **Max<sub>STD</sub>**  | 2.748 | 1.293 | 0.164 | 0.478 |
|       | **Min<sub>STD</sub>**  | 1.114 | 0.197 | 0.040 | 0.180 |
| **WERM** | **Mean<sub>STD</sub>** | 0.060 | 0.088 | 0.070 | 0.056 |
|       | **Max<sub>STD</sub>**  | 0.160 | 0.122 | 0.098 | 0.077 |
|       | **Min<sub>STD</sub>**  | 0.022 | 0.058 | 0.038 | 0.035 |

### Spread of FNMR and FMR, beyond WERM values

This is an extended version of Table 4, shows the spread of FMR and FNMR, in addition to TMR and WERM values.

#### VGGFace2 Gender

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 93.55  | 1.6477 | 2.5718 | 1.0557 | 95.48  | 1.4042 | 1.9011 | 1.0372 | 96.71  | 1.2908 |
| FSN         | 92.32  | 1.7575 | 3.0506 | 1.0125 | 95.36  | 1.3947 | 1.8498 | 1.0515 | 96.76  | 1.3059 |
| M1.1        | 93.43  | 1.1649 | 1.1092 | 1.2235 | 95.65  | 1.0977 | 1.0623 | 1.1343 | 96.67  | 1.0997 |
| M2.1        | 93.63  | 1.2033 | 1.1608 | 1.2474 | 95.77  | 1.0932 | 1.0662 | 1.1208 | 96.63  | 1.1092 |
| M3          | 92.98  | 1.1779 | 1.0507 | 1.3204 | 95.32  | 1.1346 | 1.1289 | 1.1404 | 96.67  | 1.0445 |
| M4          | 93.35  | 1.3064 | 1.3950 | 1.2235 | 95.36  | 1.1233 | 1.0974 | 1.1499 | 96.71  | 1.1540 |
| M5          | 93.55  | 1.3906 | 1.6739 | 1.1553 | 95.44  | 1.1811 | 1.2595 | 1.1076 | 96.67  | 1.0505 |

#### VGGFace2 Gender Balanced

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 93.02  | 1.7456 | 2.8365 | 1.0742 | 95.40  | 1.4696 | 2.0760 | 1.0403 | 96.63  | 1.2624 |
| FSN         | 91.46  | 1.7486 | 2.9466 | 1.0376 | 95.11  | 1.4429 | 1.8986 | 1.0966 | 96.67  | 1.2761 |
| M1.1        | 93.35  | 1.1637 | 1.1068 | 1.2235 | 95.65  | 1.1080 | 1.0823 | 1.1343 | 96.67  | 1.0525 |
| M2.1        | 93.55  | 1.2197 | 1.1779 | 1.2631 | 95.77  | 1.1014 | 1.0823 | 1.1208 | 96.63  | 1.0686 |
| M3          | 92.98  | 1.1723 | 1.0409 | 1.3204 | 95.32  | 1.1426 | 1.1449 | 1.1404 | 96.67  | 1.0408 |
| M4          | 93.14  | 1.3244 | 1.4249 | 1.2309 | 95.32  | 1.1330 | 1.1257 | 1.1404 | 96.63  | 1.1258 |
| M5          | 93.06  | 1.4569 | 1.8298 | 1.1600 | 95.28  | 1.2022 | 1.3003 | 1.1115 | 96.67  | 1.0408 |

#### VGGFace2 Ethnicity

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 93.76  | 3.8094 | 10.4621 | 1.3871 | 95.65  | 4.0101 | 12.1923 | 1.3189 | 96.80  | 1.9320 |
| FSN         | 92.69  | 3.3962 | 7.2071  | 1.6004 | 95.65  | 4.0190 | 12.1577 | 1.3286 | 96.63  | 1.9067 |
| M1.1        | 92.85  | 1.5870 | 1.5414  | 1.6340 | 95.73  | 1.3594 | 1.6506  | 1.1195 | 96.76  | 1.6203 |
| M2.1        | 92.28  | 2.1288 | 2.3411  | 1.9358 | 95.69  | 1.4253 | 1.6962  | 1.1977 | 96.71  | 1.3468 |
| M3          | 92.98  | 2.5158 | 4.0568  | 1.5601 | 95.52  | 2.6485 | 5.9303  | 1.1828 | 96.80  | 1.6644 |
| M4          | 94.00  | 2.6577 | 5.0359  | 1.4026 | 95.69  | 3.7550 | 11.7510 | 1.1999 | 96.84  | 1.7912 |
| M5          | 93.92  | 3.4323 | 8.6270  | 1.3656 | 95.65  | 3.6006 | 9.8291  | 1.3189 | 96.80  | 1.9328 |

#### VGGFace2 Ethnicity Balanced

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 88.62  | 6.4436 | 27.7412 | 1.4967 | 94.25  | 6.0192 | 27.7466 | 1.3058 | 96.51 | 2.9195 |
| FSN         | 86.57  | 11.1599 | 78.3731 | 1.5891 | 94.05 | 5.2970 | 22.5922 | 1.2419 | 96.35 | 3.8272 |
| M1.1        | 93.26  | 2.0317 | 2.6872 | 1.5361 | 95.85 | 2.0109 | 3.6119 | 1.1195 | 96.71 | 1.9065 |
| M2.1        | 93.18  | 2.5456 | 3.6084 | 1.7959 | 95.85 | 1.8519 | 3.0058 | 1.1410 | 96.76 | 1.7582 |
| M3          | 93.43  | 3.3406 | 8.1677 | 1.3663 | 95.69 | 2.6263 | 5.8313 | 1.1828 | 96.76 | 2.3642 |
| M4          | 92.65  | 3.6487 | 9.9694 | 1.3354 | 95.03 | 2.8246 | 5.8324 | 1.3679 | 96.51 | 1.9404 |
| M5          | 88.91  | 6.1117 | 27.7412 | 1.3465 | 93.72 | 6.0566 | 27.7466 | 1.3221 | 96.22 | 3.6257 |

#### RFW Original

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 24.22  | 2.5246 | 5.8430 | 1.0908 | 63.05 | 2.5402 | 5.8430 | 1.1043 | 89.14 | 3.4611 |
| FSN         | 2.19   | 6.8737 | 46.9036 | 1.0073 | 55.81 | 3.0454 | 8.5076 | 1.0901 | 88.60 | 4.5858 |
| M1.1        | 33.11  | 1.6129 | 2.1090 | 1.2334 | 67.13 | 2.0791 | 2.6734 | 1.6169 | 89.20 | 2.7097 |
| M2.1        | 33.38  | 1.4072 | 1.6134 | 1.2274 | 65.35 | 2.0301 | 2.6734 | 1.5415 | 90.41 | 7.0568 |
| M3          | 27.99  | 1.7419 | 2.6734 | 1.1349 | 62.17 | 2.2668 | 3.5565 | 1.4449 | 88.92 | 3.8758 |
| M4          | 26.29  | 2.0549 | 3.5565 | 1.1874 | 62.25 | 2.7727 | 5.8547 | 1.3131 | 89.60 | 3.5602 |
| M5          | 25.63  | 2.2587 | 4.7538 | 1.0732 | 62.54 | 2.5204 | 5.8430 | 1.0872 | 90.05 | 3.1712 |

#### RFW Random

| **Network** | **E1** | **E2** | **E3** | **E4** | **E5** |
|-------------|--------|--------|--------|--------|--------|
| **Metrics** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** | **TMR &uarr;** | **WERM &darr;** |
| Baseline    | 60.25  | 2.0418 | 3.6295 | 1.1487 | 89.66 | 2.7152 | 5.8372 | 1.2630 | 98.08 | 2.3202 |
| FSN         | 56.15  | 3.4326 | 10.4603 | 1.1264 | 87.89 | 3.2014 | 8.2447 | 1.2431 | 98.10 | 3.0989 |
| M1.1        | 68.35  | 1.9580 | 2.6734 | 1.4340 | 90.55 | 1.7059 | 1.6134 | 1.8036 | 98.37 | 1.5468 |
| M2.1        | 63.53  | 1.4274 | 1.5051 | 1.3537 | 90.31 | 1.9231 | 2.1027 | 1.7588 | 97.97 | 1.7707 |
| M3          | 64.25  | 1.7578 | 2.1090 | 1.4651 | 89.30 | 2.2723 | 2.6734 | 1.9314 | 98.09 | 1.6354 |
| M4          | 64.11  | 1.7085 | 2.1090 | 1.3840 | 90.84 | 2.6720 | 4.7396 | 1.5064 | 98.06 | 2.5022 |
| M5          | 60.57  | 2.5452 | 5.8430 | 1.1087 | 86.83 | 3.4545 | 9.4980 | 1.2564 | 97.46 | 6.7419 |


## License
This project is licensed under the MIT License - see the LICENSE file for details.
