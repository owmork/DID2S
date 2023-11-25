# DID2S 1.0.2

- Huge speedup with many fixed effects with the assist from @etiennebacher
- Only rename to DID2S

# DID2S 1.0.1

- One line change sped-up big datasets something like 15x *facepalm*

# DID2S 0.7.0

- Add `ARMA_64_BIT` for larger matricies

# DID2S 0.6.0

- Added `estimator` argument to `event_study` and added vignette discussing the different estimators' assumptions
- Fixed "seperate" argument typo in `plot_event_study`, which may break some previous code (https://github.com/kylebutts/DID2S/pull/15/) 


# DID2S 0.5.0

- Made code more robust by improving sparse model matrix creation

- Rewrote covariance matrix creation to be faster and more robust

- Improved block bootstrapping code using `boot::boot`

- Fixed Sun and Abraham bug in `event_study`, h/t Frederik Noack
	

# DID2S 0.4.0

- Add `event_study` and `plot_event_study` functions

- Seperated `did_imputation` to new package `didimputation`

# DID2S 0.3.0

- Add `did_imputation` following Borusyak, Jaravel, and Spiess (2021)

- Speed up DID2S

# DID2S 0.2.0

- Use sparse matrices to use much less memory

- Fix analytic standard errors when using weights

# DID2S 0.1.0

- Correct and robust standard errors
