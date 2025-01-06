# Robust Amortized Bayesian Inference



This repository contains the code and data used in our paper [Testing and Improving the Robustness of Amortized Bayesian Inference for Cognitive Models](https://arxiv.org/abs/2412.20586). In this paper, we test the robustness of Amortized Bayesian Inference (ABI) to outliers with empirical influence function and breakdown point plots, based on two example models: 1. a toy example (i.e., estimating $\mu$ in a 1D normal distribution) and Drift Diffusion Model (DDM). We then propose a data augumentation or noise injection approach to enhance the robustness of ABI, and find that adding noises from a Cauchy distribution to training data greatly improve the robustness of ABI.

The details of the method are described in our paper:

Wu, Y., Radev, S., & Tuerlinckx, F. (2024). Testing and Improving the Robustness of Amortized Bayesian Inference for Cognitive Models. 
<em>arXiv preprint arXiv:2412.20586</em>, available for free at: [https://arxiv.org/abs/2301.11873](https://arxiv.org/abs/2412.20586).

## Cite

```bibtex
@article{wu2024testing,
  title={Testing and Improving the Robustness of Amortized Bayesian Inference for Cognitive Models},
  author={Wu, Yufei and Radev, Stefan and Tuerlinckx, Francis},
  journal={arXiv preprint arXiv:2412.20586},
  year={2024}
}
```

The repository is divided into four distinct parts according to the structure of the paper.
## [1 parameter recovery study](1 parameter recovery study)

### [jupyter notebook](1 parameter recovery study/notebook)
- [parameter recovery study](1 parameter recovery study/notebook/parameter recovery study.ipynb): code for simulating the choice reaction data, code for performing the inference with ABI and EZ Diffusion, code for comparing the inference of ABI, EZ Diffusion, and JAGS, code for code for comparing the summary statistics learned by BayesFlow and EZ Diffusion.
- [validation_sims_ez](1 parameter recovery study/notebook/validation_sims_ez): simulated choice reaction data for reproducing the results

### [network](1 parameter recovery study/networks)
- stored networks for ABI inference in this section for reproducibility

### [JAGS related files](1 parameter recovery study/JAGS related files)
- [data_bf](1 parameter recovery study/JAGS related files/data_bf.txt): data input into JAGS for inference
- [JAGS model](1 parameter recovery study/JAGS related files/JAGS model.txt): JAGS model for inference
- [JAGS](1 parameter recovery study/JAGS related files/JAGS.R): Making inference on the 500 datasets in JAGS with R
- [posterior_mean_JAGS](1 parameter recovery study/JAGS related files/posterior_mean_JAGS.txt): the marginal posterior mean of estimates
- [posterior_sd_JAGS](1 parameter recovery study/JAGS related files/posterior_sd_JAGS.txt): the marginal posterior standard deviation of estimates

### [multivariate random forest](1 parameter recovery study/multivariate random forest)
This folder contains the R code and data for performing the multivariate random forest test in the <em>Interpreting the Learned Summary Statistics<em> section.

## [2 toy example](2 toy example)

### [jupyter notebook](2 toy example/notebook)
- [toy example](2 toy example/notebook/toy example.ipynb): code for sections with the toy example, i.e., the training, testing, and costs for both the standard (non-robust) and robust $\mu$ estimators.

### [networks](2 toy example/networks)
- stored networks for ABI inference in the toy example sections for reproducibility

### [percentage of outliers](2 toy example/Percentage of outliers.R)
- stored the R code for reproducing the results in Table 5.

## [3 ddm](3 ddm)

### [jupyter notebook](3 ddm/notebooks)
- [ddm estimator training](3 ddm/notebooks/ddm estimator training.ipynb): code for training the standard (non-robust) and robust DDM estimators.
- [diffusion_functions](3 ddm/notebooks/diffusion_functions.py): functions enables training of DDM estimators, such as the simulator function of a single diffusion trial, the prior, and the configurator.
- [ddm EIF BP](3 ddm/notebooks/ddm EIF BP.ipynb): code for reproducing the empirical influence function and breakdown point plots for DDM estimators, code for the costs of robustness of DDM estimators.
- 
### [networks](3 ddm/networks)
- stored networks for ABI inference in the DDM example sections for reproducibility

## [4 real data problem](4 real data problem)

### [jupyter notebook](4 real data problem/notebook)
- [4 real data problem](4 real data problem/notebook/4 real data problem.ipynb): code for fitting the <em>rr98<em> dataset with the standard and robust ddm estimators
- [robust ddm estimator training](4 real data problem/notebook/robust ddm estimator training.ipynb): code for training the robust DDM estimator (GPU) 
- [standard ddm estimator training](4 real data problem/notebook/standard ddm estimator training.ipynb): code for training the standard DDM estimator (GPU) 
- 
### [networks](4 real data problem/network)
- stored networks for ABI inference in the real data example section for reproducibility

### [R related files](1 parameter recovery study/R related files)
- contains the <em>rr98<em> dataset.

## License

MIT
