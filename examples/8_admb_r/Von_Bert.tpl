//=============================================================
// File: c:/1work/Modelling/QFC_workshop/examples/8_admb_r/Von_Bert.tpl
// Created: 12/04/13 7:29 PM
//
// DESCRIPTION:
//
// Model: Von Bertalanffy growth curve 
// Parameters: Linf, k, t0
// Fitted data: random sample of lake whitefish collect from southern
// Lake Huron in 2009
// Likelihood: sums of squares
// Notes:
// Warning:
// 
//=============================================================

DATA_SECTION

  init_int Linf_L	// lower bound for Linf
  init_int Linf_U	// upper bound for Linf
  init_int nobs
  init_matrix data(1,nobs,1,2)

PARAMETER_SECTION

  init_bounded_number Linf(Linf_L,Linf_U,1)
  init_number k
  init_number t0

  vector Aobs(1,nobs)
  vector Lobs(1,nobs)
  vector Lpred(1,nobs)

  sdreport_number k2  //so mcmc works

  number RSS
  objective_function_value f

PRELIMINARY_CALCS_SECTION

  Aobs=column(data,1);
  Lobs=column(data,2);

PROCEDURE_SECTION

  vb();
  RSS=norm2(Lobs-Lpred);
  f=(nobs/2)*log(RSS/nobs);

FUNCTION vb

  Lpred=Linf*(1-mfexp(-k*(Aobs-t0)));
  k2 = k;  //so mcmc works
  if (mceval_phase())
    { 
    write_mcmc();
    }

FUNCTION write_mcmc
  mcmc_iteration++;
  if(mcmc_iteration == 1)
    mcmc_report<<"Linf,k,t0"<<endl;
  mcmc_report<<Linf<<","<<k<<","<<t0<<endl;

GLOBALS_SECTION
  #include <fstream>
  #include "admodel.h"
  #include "admb2r.cpp" 
  int mcmc_iteration = 0;
  std::ofstream mcmc_report("mcmc.csv");

REPORT_SECTION
  #include "make-Rfile.cxx"  //  for ADMB2R 
  report << "Age obs" << endl;
  report <<  Aobs  << endl;
  report << "Lobs" << endl;
  report <<  Lobs  << endl;
  report << "Lpred" << endl;
  report <<  Lpred  << endl;
  report << "RSS" << endl;
  report <<  RSS  << endl;
  report << "Nobs" << endl;
  report <<  nobs  << endl;



