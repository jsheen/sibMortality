# ------------------------------------------------------------------------------
# @description: script to understand and simulate results from Masquelier 2012
# 
# @name: Justin Sheen
# @date: June 9, 2022
# ------------------------------------------------------------------------------

# 1. UNPD and WHO calculate mortality rates, discrepancies based on choice of mortality schedule, AIDS-death estimation
# - mortality schedule may be based on trends in childhood survival, which may not reflect true mortality among uninfected adults
# - childhood mortality may be estimated from mothers' first-hand information of child survival, but no equivalent survey exists
#   for adults. For adult deaths we have:
#   (1) orphanhood status (whether parents of children survived)
#   (2) recent household deaths reported by census respondents
#   (3) survival of maternal siblings in large-scale survesy
# - Sibling survival data has had increasing acceptance because of opimtism of Gakidou and King (2006), which found a positive
#   correlation between number of siblings and mortality. As number of siblings increase, so does the rate of mortality, so 
#   we can design a weighting scheme to correct for this bias, and get a better estimate of mortality after correcting this
#   selection bias.
# - This paper is a critique that shows that Gakidou and King (GK) has overestimated adult mortality, particularly among
#   males, 'because they have not been adjusted to the sampling frame.' This paper also shows that past declines in (1) fertility
#   (2) mortality, can create spurious associations between sibship size and mortality, but this may not necessarily translate
#   into selection bias. Finally, this paper shows that there is empirical evidence for a negative correlation between sibship
#   size and mortality in the form of a negative correlation between number of sisters and mortality.

# 2. Sibling histories can provide direct estimates:
# - observed number of deaths divided by the corresponding person-years. Indirect techniques are also available where proportions 
#   of surviving siblings are converted into survival probabilities, but are not preferred. However, samples sizes may be small for 
#   computation of national age-specific death rates, without introducing some smoothing. This may be overcome by pooling surveys in 
#   a regression model to 'borrow strength' from neighboring countries.
# - However, they are somewhat suspect to be filled with selection biases, that are unknown, and also unknown how to correct for.
#   For instance, respondents may not know the whereabouts of siblings, or may not be aware of those that died when they were young.
#   These are both examples of biases that arise from omissions.
# - In 17 countries of sub-Saharan Africa, at least two DHS have been conducted less than 10 years apart with a maternal mortality module,
#   which gives a way to see how badly mortality rate completeness decays with time from the survey. One paper found that the completeness
#   was 83% for females around 6 to 9 years prior to the survey, and 91% for males around 3 to 6 years prior to the survey. 

# * Poisson regression model used for estimates then introduced, include here once there is something to simulate
# - This model is for 'background mortality' i.e. not AIDS-related. We assume it follows a log-linear pattern (the relationship
#   between the predictors and outcome is such that it is linear in multi-dimensioanl space if we log-transform the outcome). Predictors
#   are functions of variables such as the age, age group, sex, country, and year, and from the regression we get the estimates of
#   each of these effects. Mortality is not assumed to be time dependent, except in countries where HIV prevalence is over 1 %. 
#   Overall magnitude of mortality, as well as sex differences, vary by country.
# - Each observation is a 1 or 0 in the outcome, for each person-period, with filled out predictors (e.g. age, calendar year, country)

# 3. Sibling histories also have structural limitations:
#   (1) groups of siblings with high mortality are underrepresented because no information is available without a surviving member
#   (2) low mortality sibships are overrepresented because more likely that more siblings will be surveyed
#   (3) respondents usually not counted in denominator, which biases mortality rate upward
#   ...however, Trussell and Rodriguez (1990) demonstrated that these three structural limitations cancel one another if (1) the siblings
#   interviewed constitute a probability sample of the population (2) the experience of respondents is excluded from calculation (3) no
#   correlation exists between mortality and sibship size. More specifically, they show that PD (the proportion of observed deaths
#   averaged over all sibships of all varying sizes) = p. (3) is important in order for p to be independent of n, and that there is
#   a single p. (2) is important just for the calculation. (1) is important because this shows mathematically what would happen
#   if all siblings were interviewed, and we assume that if we take a SRS from the population instead, it should hold with a large 
#   enough sample size. There is a numerical example given in the text that shows an overestimation in mortality rate if there is
#   only 1 respondent per sibship, and this bias is directly proportional to sibsize and level of mortality. Therefore, usually duplicated
#   sibships will all be included in calculuation.
# - Methodological choices vary in terms of weights used, and in the inclusion (or not) of person-years lived by respondents. in the DHS
#   survey, selection biases concerning an assocation between sibship size and mortality were not corrected, though more recently some
#   approaches including adding the respondent into the denominator, have somehow been shown to correct selection biases.

# 4. A weighting scheme, introduced by Gakidou and King, corrects for selection biases if there is an association between mortality and sibship size
# - First step is to weight the data to recover death rates for all sibships with at least one surviving member. The second step is to
#   extrapolate to recover death rates for sibships with no surviving members.
# - The first step is to compute family level weights of the form Bi / Si where Bi is the number of sibling of individual i at the
#   start of the observation period, and Si is the number of surviving siblings at the time of the survey. This will give less importance
#   to sibships with high sibling survival. Respondents are included in both Bi and Si, and the weights are designed to be applied
#   to proportions of dead siblings reported by *each* survivor, i.
# - Once this first step is applied, the observed proportion is now very close to the real probability of dying, the difference being
#   entirely attributable to the omission of sibships without survivors.
# - The second step of the procedure is to estimate the number of deaths in sibships which everyone died. This is given by a parameter
#   psi, which GK proposed to estimate through a regression model. In this regression model, the number of observed deaths is regressed
#   on the *number* (not proportion) of surviving siblings (s=1, 2, 3,...). The model is then used to extrapolate back to s=0. Model fits
#   were strikingly good in examples based on DHS surveys. Unfortunately, the authors note that nothing can guarantee the accuracy of
#   extrapolating to the point at which s=0. There are some methods though to demonstate whether accuracy is compromised, such as looking
#   at goodness of fit, and prediction when witholding one sibship at a time. A salient point is that unobserved deaths are almost exclusively
#   from small sibships (n <= 3) which will play only a small part in shaping the overall distribution of deaths by numbers of survivors.

# 5. Insights from microsimulated populations
# - Survey data is complicated. In DHS surveys, only some individuals are eligble to respond to the sibling module. Risks of dying
#   vary over time, as well as by age and sex (of siblings). "Hence, even if it were correct to assume that mortality rates are unrelated to sibsize,
#   the fact that death risks are drawn from different distributions add some complexity."
# - Selection biases arise because sibships are sampled with probability proportional to survivors, rather than the number of 
#   siblings at the start of the observation period. But when using DHS data, Bi should not include every sibling, such as siblings
#   who died outside the observation window, or who are not members of the cohort of respondents. Also, the second step of GK becomes
#   more complicated because we need the number of adult deaths that occurred in sibships with no eligible respondent, as well as the
#   corresponding person-years.
# - Microsimulations can be used to create sibling histories akin to those collected in surveys. Predefined vital rates are converted
#   to waiting times preceding particular events. These events are then assigned to fictitious individuals, and in some models, marriages
#   are also assigned.
# - The distribution of sibsizes observed in DHS surveys are shaped by past trends in mortality and fertility, and in this paper, the
#   author simulates populations that mimic the demographic trajectories in 41 countries of sub-Saharan Africa. Simulations are calibrated
#   with estimates from the 2008 revision of the world population prospects, and age-specific fertility rates and non-AIDS life tables
#   are derived from UNPD estimates. HIV infection rates are computed from UNAIDS incidence rates. The simulations start in 1900 and
#   run under conditions of stability until 1951, when death and birth rates start exhibiting annual variation. Each run is repeated
#   10 times and final populations are merged to reach 300,000 survivors in 2010. Because this simulation is on the individual level,
#   we can find out which individuals are siblings, as well as birth and death dates, which are used to compute underlying mortality
#   rates as well as other aggregate indicators, with event-history analysis.
# - Figure 2 shows how well the survivorship age distributions from simulations replicate those found in the UNPD estimates.
# - Every individual is interviewed, as though a census were being conducted. If there is a way to include household structure into
#   these microsimulations, we would do it. Or maybe we wouldn't do it, because Trussell and Rodriguez point out that as long as all
#   sisters are interviewed, surveying will not distort estimates of sampling.

# 6. DHS Analog calculation
# - They vary results depending on the respondents (four scenarios)
# - "For the decade preceding the fictitious census, sibling estimates approach underlying mortality rates in each of the four scenarios."
# - Mortality rates for males can be properly estimated from female respondents. Counting or not counting own reports in the exposure has
#   no effect. Sibships with low female mortality are underrepresented in the data relative to brothers (why?), but this does not 
#   introduce a bias because death risks are assumed to be uncorrelated with sibsize. Mortality rates for males in sibships with no
#   sisters are assumed to be identical to mortality rates in sibships that include sisters.
# - In the case of only collecting results from adults, it would be unwise to use DHS estimates to reconstruct adult mortality trends
#   for more than 10 years prior to the survey. But strikingly, even when only females aged 15 to 49 are interviewed, and there are only
#   8000 ish respondents, the estimates are unbiased.
# - In this example, 27% of female deaths between ages 15 and 60 that occurred in the last decade are mentioned only once, 20% are 
#   mentioned twice, 19% are mentioned at least three times, and 34% remain unobserved.

# 7. Use of GK weights
# - The mechanism developed by Gakidou and King has been applied to different types of surveys, including DHS surveys, and World Health
#   surveys. But the author argues that applying this has been flawed in several ways.
# - First, there is some confusion over the weighted averages of proportions of dead siblings per survivor.
# - Second, most attempts to apply the weighting scheme did not discriminate between adult siblings and siblings who died in childhood,
#   and sex-specific weights were not computed. This is detrimental, as GK warned that you need to ask respondents about relatives in
#   the same group (e.g. males age 40 to 44 can only respond about siblings in their own group). Bi has been computed as the original
#   sibsize, and Si has been calculated as all siblings that survive by time of survey, which is inappropriate because sibling data
#   are collected from adults only, typically from women of reproductive age.
# - Ironically, these two errors can create even larger biases than the selection biases they aim to protect against. When all ages are
#   respondents, then the weights (of the form Bi / Si) work well. But when women of reproductive age are the only eligible respondents,
#   mortality is overestimated (these are all seen in Figure 4). This may be due to the lack of data on sibships without any surviving
#   female respondent. So reported estimates of very high mortality may actually just be due to this weighting scheme.

# 8. Comparisons between alternative DHS estimates
# - (1) Standard estimates are obtained by excluding own reports and using only DHS sample weights (2) Adjusted estimates are computed
#   by adding own reports in the calculation of person-years and by weighting the data by the inverse of the number of surviving sisters
#   aged 15 to 49 (3) Inflated estimates are obtained with weights of the form Bi / Si where Bi and Si refer to the total number of siblings
#   ever born and surviving. Figure 5 shows the results as long as the standard method (1) is unbiased. 

# 9. Reconsideration of sibship and mortality assocation
# - There appears to be a significant correlation in 10 of 30 countries considered here. However, in others there seems to be the
#   counter-intutive finding that larger sibships will actually increase odds of not dying. There are alternative explanations to
#   this association. Also, there may be sever recall bias: for instance there is now evidence of strong positive correlation between
#   the extent of missing data on time of death in surveys, and sibship sizes i.e. older respondents whose sibships are larger on
#   average could disproportionately underreport siblings' deaths. Pinning down exact reasons for a negative association between
#   mortality and sibsize is interesting for future research as well.
# - It seems that GK does find things that need to be re-weighted.
# - In conclusion, pros and cons to the use of sibling survey data for mortality rate. This paper shows that a positive correlation
#   between sibship size and mortaliy rate may be confounded by trends in mortality and fertility. When restricting to one cohort
#   of females, he finds that the correlation may be negative. This negative correlation means that standard estimates will be lower,
#   but only by 5 to 10%. The central problem in past research is the failure to adapt the weighting scheme to the characteristics of
#   siblings and respondents, resulting in overestimates and distortions of mortality sex ratios.
# - Optimal corrections include: more optimal weighting schemes beyond GK, since GK was applied on the sibship level rather than the
#   individual level. Second, Si should not refer to the number of surviving siblings, but instead to the number of potential respondents.
#   Third, no adjustment for the zero-female-respondent is currently satisfactory, as the quadratic regression model results in 
#   overestimates for the number of unobserved deaths. Hierarchical modeling might be a way to shrink the group-specific adjustments
#   toward an overall mean when adult deaths remain sparse. Distributional assumptions might also be made. Also, another type of
#   correction in lieu of the GK correction is to reweight sibsize-specific mortality rates according to an estimated distribution of
#   sibship sizes. 













































