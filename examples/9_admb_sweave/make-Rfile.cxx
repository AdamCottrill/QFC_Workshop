// don't forget to add the following lines to your tpl:
// GLOBALS_SECTION
//  #include <admodel.h>
//  #include <admb2r.cpp>
//
// #include "make-Rfile.cxx" // ADMB2R code

open_r_file(adprogram_name + ".rdat", 6, -999);

  // Example of metadata stored in an INFO object (R list)
  open_r_info_list("info", true);
  //wrt_r_item("model", (char*)(adprogram_name));
     wrt_r_item("species", "LakeWhitefish");
     wrt_r_item("units.len", "mm");
  close_r_info_list();
  
  // scalars need to be written to 'info_list' objects
  open_r_info_list("dims", false);
     wrt_r_item("nobs", nobs);
  close_r_info_list();
  
  // a matrix
  open_r_matrix("data");
    wrt_r_matrix(data,1,1);
  close_r_matrix();

  // a vector
  wrt_r_complete_vector("Lpred", Lpred);
  
close_r_file();
