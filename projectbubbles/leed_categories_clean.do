use "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_01.dta", clear
append using "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_02.dta"
append using "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_03.dta", force
append using "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_04.dta", force
append using "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_05.dta", force

drop if filename == ""
split projectname, parse(-)
replace projectname2 = projectname1 if projectname2 == ""
rename projectname2 address 

split date, parse(/)
rename date3 year
rename possible total_points
rename pos possible
destring possible, replace force



destring neg, replace force
replace neg = 0 if neg == .
replace possible = 0 if possible == .
gen total_possible = neg + possible

*tag missing obnservations for for address * 987 dont have address out of  *
gen missing_address= 0
replace missing_address = 1 if address == ""
replace address = "126 Border Street" if missing_address == 1


keep total_possible year address total_points fieldname date


*clean for duplicate categoires in each fieldname 
by address fieldname, sort: gen nvals = _n == 1 
drop if nvals == 0

/////////////////////////////////////////////////////////

****CREATES DATASET AT THE PROJECT LEVEL*****

/////////////////////////////////////////////////////////

preserve
bysort address: egen total_all_cats = sum(total_points)
bysort address: egen possible_all_cats = sum(total_possible)

sort address
collapse (firstnm) total_all_cats possible_all_cats, by(address)
save "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/total_points_by_project.dta", replace

restore 


*bys fieldname: egen max_points=max(total_points)

*leave sum of possibel points per fieldname for every year. 
*bys fieldname: egen tot_possible_by_cat = total(total_possible)
*gen possible_percentage = total_possible/tot_possible_by_cat



/////////////////////////////////////////////////////////

****CREATES DATASET AT THE LEED CATEGORY LEVEL BY YEAR*****

/////////////////////////////////////////////////////////
preserve 
sort total_points fieldname 
collapse (sum) total_possible, by(fieldname year)
drop if year == ""
destring year, replace force
xtset year 

*format year variable
replace year = year + 2000 

twoway (scatter total_possible year if fieldname == "MaterialsandResources", mcolor(red) msize(small)) ///
(line total_possible year if fieldname == "MaterialsandResources", ///
lcolor(black) lwidth(vthin)), ///
ylabel(, labsize(small) labgap(tiny)) ///
xlabel(#10, labsize(small) labgap(tiny)) ///
title(Water Efficient Landscaping, size(medsmall) color(black) position(6) margin(small) nobox) ///
legend(off) xsize(3) ysize(3) ///
graphregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white)) ///
plotregion(fcolor(white) lcolor(white) ifcolor(white) ilcolor(white))


*yscale(range(0 (500) 1500)) yla(0 (500) 1500) ///

save "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/total_possible_points_by_leedcat.dta", replace
reshape wide total_possible, i(fieldname) j(date)
export delimited using "/Users/arianna/Desktop/data.csv", replace
restore 
*(firstnm) projectname1 


/////////////////////////////////////////////////////////

****CREATES DATASET FOR THE BROAD LEED CATEGORIES BY YEAR*****

/////////////////////////////////////////////////////////

destring year, replace

gen broad_categories = ""
replace broad_categories = "location and transportation" if fieldname == "AltTran-Bicycle"
replace broad_categories = "location and transportation" if fieldname == "AltTran-PublicTran"
replace broad_categories = "location and transportation" if fieldname == "Altran-LowEmit"
replace broad_categories = "location and transportation" if fieldname == "Altran-Parking"
replace broad_categories = "location and transportation" if fieldname == "Altran-Parking"
replace broad_categories = "location and transportation" if fieldname == "DevelopmentDensity"
replace broad_categories = "location and transportation" if fieldname == "On-Site"


replace broad_categories = "sustainable sites" if fieldname == "Brownfield"
replace broad_categories = "sustainable sites" if fieldname == "HeatIdland-non-Roof"
replace broad_categories = "sustainable sites" if fieldname == "HeatIsland-Roof"
replace broad_categories = "sustainable sites" if fieldname == "LightPollution"
replace broad_categories = "sustainable sites" if fieldname == "SiteDev-MaxOpen"
replace broad_categories = "sustainable sites" if fieldname == "SiteDev-Protect"
replace broad_categories = "sustainable sites" if fieldname == "SiteSelection"
replace broad_categories = "sustainable sites" if fieldname == "Sustainable Sites"



replace broad_categories = "energy and atmosphere" if fieldname == "EnergyandAtmosphere"
replace broad_categories = "energy and atmosphere" if fieldname == "EnhancedComm"
replace broad_categories = "energy and atmosphere" if fieldname == "EnhancedRefrig"
replace broad_categories = "energy and atmosphere" if fieldname == "GreenPower"
replace broad_categories = "energy and atmosphere" if fieldname == "OutdoorAir"




replace broad_categories = "materials and resources" if fieldname == "Building Reuse - Maintain 50%"
replace broad_categories = "materials and resources" if fieldname == "Building Reuse - Maintain Existing Walls"
replace broad_categories = "materials and resources" if fieldname == "CertifiedWood"
replace broad_categories = "materials and resources" if fieldname == "ConstructionIAQ-Before Occ"
replace broad_categories = "materials and resources" if fieldname == "ConstructionIAQ-During"
replace broad_categories = "materials and resources" if fieldname == "ConstructionWaste"
replace broad_categories = "materials and resources" if fieldname == "LowEmit_Adhesives"
replace broad_categories = "materials and resources" if fieldname == "LowEmit_CompositeWood"
replace broad_categories = "materials and resources" if fieldname == "LowEmit_Flooring"
replace broad_categories = "materials and resources" if fieldname == "LowEmit_Paints"
replace broad_categories = "materials and resources" if fieldname == "Material Reuse"
replace broad_categories = "materials and resources" if fieldname == "MaterialsReuse"
replace broad_categories = "materials and resources" if fieldname == "MaterialsandResources"
replace broad_categories = "materials and resources" if fieldname == "RecycledContent"



replace broad_categories = "indoor quality" if fieldname == "Controlability-Lighting"
replace broad_categories = "indoor quality" if fieldname == "Controlability-Thermal"
replace broad_categories = "indoor quality" if fieldname == "Daylight"
replace broad_categories = "indoor quality" if fieldname == "Daylight"
replace broad_categories = "indoor quality" if fieldname == "IncreasedVent"
replace broad_categories = "indoor quality" if fieldname == "IndoorChem"
replace broad_categories = "indoor quality" if fieldname == "IndoorEnvironment"
replace broad_categories = "indoor quality" if fieldname == "Measurement & Verficaiton"
replace broad_categories = "indoor quality" if fieldname == "ThermalComfort Design"
replace broad_categories = "indoor quality" if fieldname == "ThermalComfortVerification"
replace broad_categories = "indoor quality" if fieldname == "Views"



replace broad_categories = "innovation" if fieldname == "InnovationandDesign"
replace broad_categories = "innovation" if fieldname == "Tenant Design"



replace broad_categories = "water efficiency" if fieldname == "InnovativeWasteWaterTech"
replace broad_categories = "water efficiency" if fieldname == "Stormwater-Quantity"
replace broad_categories = "water efficiency" if fieldname == "Stormwater_Quality"
replace broad_categories = "water efficiency" if fieldname == "WaterEfficiency"
replace broad_categories = "water efficiency" if fieldname == "WaterEfficientLandscaping"
replace broad_categories = "water efficiency" if fieldname == "WaterUseReduction"




replace broad_categories = "regional priority" if fieldname == "Optimize"
replace broad_categories = "regional priority" if fieldname == "RapIdly Renewable"
replace broad_categories = "regional priority" if fieldname == "RegionalMat"
replace broad_categories = "regional priority" if fieldname == "RegionalPriorityCredits"






save "/Users/arianna/Dropbox (MIT)/PHD/Spring_2018/11.S941_Big_Data_Visualization_Society/BDVS_Team Collaboration/data/clean_data/20_NCMR_merged.dta", replace
