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
# - 









