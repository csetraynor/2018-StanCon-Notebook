data {
  
  //----- Longitudinal submodels

  // number of long. submodels
  // NB this is fixed equal to 2 for this simplified jm.stan 
  // file. See the jm.stan file in rstanarm for more general 
  // code that allows for 1, 2 or 3 longitudinal submodels.
  int<lower=2,upper=2> M; 
  
  // population level dimensions
  int<lower=0> y_N[2]; // num observations
  int<lower=0> y_K[2]; // num predictors

  // population level data
  // NB these design matrices are evaluated at the observation times
  vector[y_N[1]] y1; // response vectors
  vector[y_N[2]] y2;  
  matrix[y_N[1],y_K[1]] y1_X; // fe design matrix
  matrix[y_N[2],y_K[2]] y2_X; 
  vector[y_K[1]] y1_Xbar; // predictor means
  vector[y_K[2]] y2_Xbar;
  
  // group level dimensions
  int<lower=0> b_N;     // num groups
  int<lower=0> b_K;     // total num params
  int<lower=0> b_KM[2]; // num params in each submodel

  // group level data
  vector[y_N[1]] y1_Z[b_KM[1]]; // re design matrix
  vector[y_N[2]] y2_Z[b_KM[2]];
  int<lower=0> y1_Z_id[y_N[1]]; // group ids for y*_Z
  int<lower=0> y2_Z_id[y_N[2]];
  
  //----- Event submodel
  
  // data for calculating event submodel linear predictor in GK quadrature
  // NB these design matrices are evaluated AT the event time and
  // the (unstandardised) quadrature points
  int<lower=0> e_K;           // num. of predictors in event submodel
  int<lower=0> a_K;           // num. of association parameters
  int<lower=0> Npat;          // num. individuals
  int<lower=0> Nevents;       // num. events (ie. not censored)  
  int<lower=0> qnodes;        // num. of nodes for GK quadrature 
  int<lower=0> Npat_times_qnodes; 
  int<lower=0> nrow_e_Xq;     // num. rows in event submodel predictor matrix
  vector[nrow_e_Xq] e_times;  // event times and quadrature points
  matrix[nrow_e_Xq,e_K] e_Xq; // predictor matrix (event submodel)
  vector[e_K] e_xbar;         // predictor means (event submodel)
  int<lower=0> basehaz_df;    // df for B-splines baseline hazard
  matrix[nrow_e_Xq,basehaz_df] basehaz_X; // design matrix (basis terms) for baseline hazard
  vector[Npat_times_qnodes] qwts; // GK quadrature weights with (b-a)/2 scaling 

  // data for calculating long. submodel linear predictor in GK quadrature
  // NB these design matrices are evaluated AT the event time and
  // the (unstandardised) quadrature points
  int<lower=0> nrow_y_Xq[2]; // num. rows in long. predictor matrix at quadpoints
  matrix[nrow_y_Xq[1],y_K[1]] y1_Xq; // fe design matrix at quadpoints
  matrix[nrow_y_Xq[2],y_K[2]] y2_Xq; 
  vector[nrow_y_Xq[1]] y1_Zq[b_KM[1]]; // re design matrix at quadpoints
  vector[nrow_y_Xq[2]] y2_Zq[b_KM[2]];
  int<lower=0> y1_Zq_id[nrow_y_Xq[1]]; // group indexing for re design matrix
  int<lower=0> y2_Zq_id[nrow_y_Xq[2]]; 

  //----- Hyperparameters for prior distributions
  
  // means for priors
  // coefficients
  vector[y_K[1]]       y1_prior_mean;
  vector[y_K[2]]       y2_prior_mean;
  vector[e_K]          e_prior_mean;
  vector[a_K]          a_prior_mean;
  vector[M]            y_prior_mean_for_intercept;
  vector<lower=0>[M]   y_prior_mean_for_aux;
  vector[basehaz_df]   e_prior_mean_for_aux;
  
  // scale for priors
  vector<lower=0>[y_K[1]] y1_prior_scale;
  vector<lower=0>[y_K[2]] y2_prior_scale;
  vector<lower=0>[e_K]    e_prior_scale;
  vector<lower=0>[a_K]    a_prior_scale;
  vector<lower=0>[M]      y_prior_scale_for_intercept;
  vector<lower=0>[M]      y_prior_scale_for_aux;
  vector<lower=0>[basehaz_df] e_prior_scale_for_aux;
  
  // lkj prior stuff
  vector<lower=0>[b_K] b_prior_scale;
  vector<lower=0>[b_K] b_prior_df;
  real<lower=0> b_prior_regularization;
}