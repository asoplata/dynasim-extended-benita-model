function [T,PYdr_v,PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12,PYso_v,PYso_iNa_PYso_B12_hNa,PYso_iK_PYso_B12_nK,PYso_iA_PYso_B12_hA,PYso_iKS_PYso_B12_mKS,IN_v,IN_iNa_IN_B12_mNa,IN_iNa_IN_B12_hNa,IN_iK_IN_B12_nK,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa,PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA,PYdr_PYso_iAMPA_PYdr_PYso_B12_res,PYdr_v_spikes,PYdr_iHVA_PYdr_B12_IHVA_PYdr_B12,PYdr_iNaP_PYdr_B12_INaP_PYdr_B12,PYdr_iAR_PYdr_B12_IAR_PYdr_B12,PYso_v_spikes,PYso_iLeak_PYso_B12_ILeak_PYso_B12,PYso_iNa_PYso_B12_INa_PYso_B12,PYso_iK_PYso_B12_IK_PYso_B12,PYso_iA_PYso_B12_IA_PYso_B12,PYso_iKS_PYso_B12_IKS_PYso_B12,IN_v_spikes,IN_iLeak_IN_B12_ILeak_IN_B12,IN_iNa_IN_B12_INa_IN_B12,IN_iK_IN_B12_IK_IN_B12,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INa_PYso_local,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INaP_PYdr_local,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_IKNa_PYso_PYdr_B12,PYdr_PYso_iAMPA_PYdr_PYso_B12_IAMPA_PYdr_PYso_B12,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_eqNaPumpTerm,PYso_PYdr_iNaCurrs_PYso_PYdr_B12_netcon,PYdr_PYso_iAMPA_PYdr_PYso_B12_normalizingFactor,PYdr_PYso_iAMPA_PYdr_PYso_B12_netcon]=solve_ode
% ------------------------------------------------------------
% Parameters:
% ------------------------------------------------------------
params = load('params.mat','p');
p = params.p;
downsample_factor=p.downsample_factor;
dt=p.dt;
T=(p.tspan(1):dt:p.tspan(2))';
ntime=length(T);
nsamp=length(1:downsample_factor:ntime);


% ------------------------------------------------------------
% Fixed variables:
% ------------------------------------------------------------
% seed the random number generator
rng_wrapper(p.random_seed);
PYso_PYdr_iNaCurrs_PYso_PYdr_B12_eqNaPumpTerm =  p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_eqNa^3 / (p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_eqNa^3 + 15^3);
PYso_PYdr_iNaCurrs_PYso_PYdr_B12_netcon =  eye(p.PYdr_Npop,p.PYso_Npop);
PYdr_PYso_iAMPA_PYdr_PYso_B12_normalizingFactor =  min(((2*p.PYdr_PYso_iAMPA_PYdr_PYso_B12_radius + (1-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_removeRecurrentBool)) / (p.PYdr_Npop/p.PYso_Npop)), p.PYso_Npop);
PYdr_PYso_iAMPA_PYdr_PYso_B12_netcon =  netconNearestNeighbors(2*p.PYdr_PYso_iAMPA_PYdr_PYso_B12_radius, p.PYso_Npop, p.PYdr_Npop, p.PYdr_PYso_iAMPA_PYdr_PYso_B12_removeRecurrentBool);


% ------------------------------------------------------------
% Initial conditions:
% ------------------------------------------------------------
% seed the random number generator
rng_wrapper(p.random_seed);
t=0; k=1;

% STATE_VARIABLES:
PYdr_v = zeros(nsamp,p.PYdr_Npop);
  PYdr_v(1,:) =  p.PYdr_vIC+p.PYdr_vNoiseIC*rand(1,p.PYdr_Npop);
PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12 = zeros(nsamp,p.PYdr_Npop);
  PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(1,:) =  p.PYdr_CaBuffer_PYdr_B12_CaBufferIC+p.PYdr_CaBuffer_PYdr_B12_CaBufferNoiseIC.*rand(1,p.PYdr_Npop);
PYso_v = zeros(nsamp,p.PYso_Npop);
  PYso_v(1,:) =  p.PYso_vIC+p.PYso_vNoiseIC*rand(1,p.PYso_Npop);
PYso_iNa_PYso_B12_hNa = zeros(nsamp,p.PYso_Npop);
  PYso_iNa_PYso_B12_hNa(1,:) = p.PYso_iNa_PYso_B12_hNaIC+p.PYso_iNa_PYso_B12_hNaNoiseIC.*rand(1, p.PYso_Npop);
PYso_iK_PYso_B12_nK = zeros(nsamp,p.PYso_Npop);
  PYso_iK_PYso_B12_nK(1,:) = p.PYso_iK_PYso_B12_nKIC+p.PYso_iK_PYso_B12_nKNoiseIC.*rand(1,p.PYso_Npop);
PYso_iA_PYso_B12_hA = zeros(nsamp,p.PYso_Npop);
  PYso_iA_PYso_B12_hA(1,:) = p.PYso_iA_PYso_B12_hAIC+p.PYso_iA_PYso_B12_hANoiseIC.*rand(1, p.PYso_Npop);
PYso_iKS_PYso_B12_mKS = zeros(nsamp,p.PYso_Npop);
  PYso_iKS_PYso_B12_mKS(1,:) = p.PYso_iKS_PYso_B12_mKSIC+p.PYso_iKS_PYso_B12_mKSNoiseIC.*rand(1, p.PYso_Npop);
IN_v = zeros(nsamp,p.IN_Npop);
  IN_v(1,:) =  p.IN_vIC+p.IN_vNoiseIC*rand(1,p.IN_Npop);
IN_iNa_IN_B12_mNa = zeros(nsamp,p.IN_Npop);
  IN_iNa_IN_B12_mNa(1,:) = p.IN_iNa_IN_B12_mNaIC+p.IN_iNa_IN_B12_mNaNoiseIC.*rand(1, p.IN_Npop);
IN_iNa_IN_B12_hNa = zeros(nsamp,p.IN_Npop);
  IN_iNa_IN_B12_hNa(1,:) = p.IN_iNa_IN_B12_hNaIC+p.IN_iNa_IN_B12_hNaNoiseIC.*rand(1, p.IN_Npop);
IN_iK_IN_B12_nK = zeros(nsamp,p.IN_Npop);
  IN_iK_IN_B12_nK(1,:) = p.IN_iK_IN_B12_nKIC+p.IN_iK_IN_B12_nKNoiseIC.*rand(1,p.IN_Npop);
PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa = zeros(nsamp,p.PYdr_Npop);
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(1,:) = p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNaIC+p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNaNoiseIC.*rand(1, p.PYso_Npop);
PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa = zeros(nsamp,p.PYdr_Npop);
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(1,:) =  p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNaIC+p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNaNoiseIC.*rand(1,p.PYdr_Npop);
PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA = zeros(nsamp,p.PYso_Npop);
  PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(1,:) =  p.PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPAIC+p.PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPANoiseIC.*rand(1,p.PYso_Npop);
PYdr_PYso_iAMPA_PYdr_PYso_B12_res = zeros(nsamp,p.PYso_Npop);
  PYdr_PYso_iAMPA_PYdr_PYso_B12_res(1,:) = zeros(1,p.PYso_Npop);

% MONITORS:
PYdr_tspike = -1e6*ones(1,p.PYdr_Npop);
PYdr_buffer_index = ones(1,p.PYdr_Npop);
  PYdr_v_spikes = zeros(nsamp,p.PYdr_Npop);
  PYdr_iHVA_PYdr_B12_IHVA_PYdr_B12 = zeros(nsamp,p.PYdr_Npop);
    PYdr_iHVA_PYdr_B12_IHVA_PYdr_B12(1,:) =p.PYdr_iHVA_PYdr_B12_gHVA.*(( 1./(1 + exp(-(PYdr_v(1,:)+20)./9)))).^2.*(PYdr_v(1,:)-p.PYdr_iHVA_PYdr_B12_EHVA);
  PYdr_iNaP_PYdr_B12_INaP_PYdr_B12 = zeros(nsamp,p.PYdr_Npop);
    PYdr_iNaP_PYdr_B12_INaP_PYdr_B12(1,:) =p.PYdr_iNaP_PYdr_B12_gNaP.*(( 1./(1 + exp(-(PYdr_v(1,:)+55.7)./7.7)))).^3.*(PYdr_v(1,:)-p.PYdr_iNaP_PYdr_B12_ENaP);
  PYdr_iAR_PYdr_B12_IAR_PYdr_B12 = zeros(nsamp,p.PYdr_Npop);
    PYdr_iAR_PYdr_B12_IAR_PYdr_B12(1,:) =p.PYdr_iAR_PYdr_B12_gAR.*(( 1./(1 + exp((PYdr_v(1,:)+75)./4)))).*(PYdr_v(1,:)-p.PYdr_iAR_PYdr_B12_EAR);
PYso_tspike = -1e6*ones(1,p.PYso_Npop);
PYso_buffer_index = ones(1,p.PYso_Npop);
  PYso_v_spikes = zeros(nsamp,p.PYso_Npop);
  PYso_iLeak_PYso_B12_ILeak_PYso_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_iLeak_PYso_B12_ILeak_PYso_B12(1,:) =-p.PYso_iLeak_PYso_B12_gLeak.*(PYso_v(1,:)-p.PYso_iLeak_PYso_B12_ELeak);
  PYso_iNa_PYso_B12_INa_PYso_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_iNa_PYso_B12_INa_PYso_B12(1,:) =p.PYso_iNa_PYso_B12_gNa.*(( (( 0.1.*(PYso_v(1,:)+33)./(1-exp(-(PYso_v(1,:)+33)./10))))./((( 0.1.*(PYso_v(1,:)+33)./(1-exp(-(PYso_v(1,:)+33)./10)))) + ((  4.*exp(-(PYso_v(1,:)+53.7)./12)))))).^3.*PYso_iNa_PYso_B12_hNa(1,:).*(PYso_v(1,:)-p.PYso_iNa_PYso_B12_ENa);
  PYso_iK_PYso_B12_IK_PYso_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_iK_PYso_B12_IK_PYso_B12(1,:) =p.PYso_iK_PYso_B12_gK.*PYso_iK_PYso_B12_nK(1,:).^4.*(PYso_v(1,:)-p.PYso_iK_PYso_B12_EK);
  PYso_iA_PYso_B12_IA_PYso_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_iA_PYso_B12_IA_PYso_B12(1,:) =p.PYso_iA_PYso_B12_gA.*(( 1./(1 - exp(-(PYso_v(1,:)+50)./20)))).^3.*PYso_iA_PYso_B12_hA(1,:).*(PYso_v(1,:)-p.PYso_iA_PYso_B12_EA);
  PYso_iKS_PYso_B12_IKS_PYso_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_iKS_PYso_B12_IKS_PYso_B12(1,:) =p.PYso_iKS_PYso_B12_gKS.*PYso_iKS_PYso_B12_mKS(1,:).^3.*(PYso_v(1,:)-p.PYso_iKS_PYso_B12_EKS);
IN_tspike = -1e6*ones(1,p.IN_Npop);
IN_buffer_index = ones(1,p.IN_Npop);
  IN_v_spikes = zeros(nsamp,p.IN_Npop);
  IN_iLeak_IN_B12_ILeak_IN_B12 = zeros(nsamp,p.IN_Npop);
    IN_iLeak_IN_B12_ILeak_IN_B12(1,:) =-p.IN_iLeak_IN_B12_gLeak.*(IN_v(1,:)-p.IN_iLeak_IN_B12_ELeak);
  IN_iNa_IN_B12_INa_IN_B12 = zeros(nsamp,p.IN_Npop);
    IN_iNa_IN_B12_INa_IN_B12(1,:) =-p.IN_iNa_IN_B12_gNa.*IN_iNa_IN_B12_mNa(1,:).^3.*IN_iNa_IN_B12_hNa(1,:).*(IN_v(1,:)-p.IN_iNa_IN_B12_ENa);
  IN_iK_IN_B12_IK_IN_B12 = zeros(nsamp,p.IN_Npop);
    IN_iK_IN_B12_IK_IN_B12(1,:) =-p.IN_iK_IN_B12_gK.*IN_iK_IN_B12_nK(1,:).^4.*(IN_v(1,:)-p.IN_iK_IN_B12_EK);
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INa_PYso_local = zeros(nsamp,p.PYso_Npop);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INa_PYso_local(1,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNa.*(( (( 0.1.*(PYso_v(1,:)+33)./(1-exp(-(PYso_v(1,:)+33)./10))))./((( 0.1.*(PYso_v(1,:)+33)./(1-exp(-(PYso_v(1,:)+33)./10)))) + ((  4.*exp(-(PYso_v(1,:)+53.7)./12)))))).^3.*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(1,:).*(PYso_v(1,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENa);
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INaP_PYdr_local = zeros(nsamp,p.PYso_Npop);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INaP_PYdr_local(1,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNaP.*(( 1./(1 + exp(-(PYso_v(1,:)+55.7)./7.7)))).^3.*(PYso_v(1,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENaP);
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_IKNa_PYso_PYdr_B12 = zeros(nsamp,p.PYso_Npop);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_IKNa_PYso_PYdr_B12(1,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gKNa.*(0.37./(1 + (38.7./PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(1,:)).^3.5))*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_netcon.*(PYso_v(1,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_EKNa);
  PYdr_PYso_iAMPA_PYdr_PYso_B12_IAMPA_PYdr_PYso_B12 = zeros(nsamp,p.PYdr_Npop);
    PYdr_PYso_iAMPA_PYdr_PYso_B12_IAMPA_PYdr_PYso_B12(1,:) =-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_gAMPA/PYdr_PYso_iAMPA_PYdr_PYso_B12_normalizingFactor.*((PYdr_PYso_iAMPA_PYdr_PYso_B12_res(1,:).*PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(1,:))*PYdr_PYso_iAMPA_PYdr_PYso_B12_netcon).*(PYdr_v(1,:)-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_EAMPA);


% ###########################################################
% Memory check:
% ###########################################################
try 
  memoryUsed = memoryUsageCallerGB(); 
  fprintf('Total Memory Used <= %i GB \n', ceil(memoryUsed)); 
end 


% ###########################################################
% Numerical integration:
% ###########################################################
% seed the random number generator
rng_wrapper(p.random_seed);
n=2;
for k=2:ntime
  t=T(k-1);
  PYdr_v_k1 =((((( p.PYdr_iAppliedCurrent_appliedStim*(t>p.PYdr_iAppliedCurrent_onset & t<p.PYdr_iAppliedCurrent_offset))))+((-(( p.PYdr_iHVA_PYdr_B12_gHVA.*(( 1./(1 + exp(-(PYdr_v(n-1,:)+20)./9)))).^2.*(PYdr_v(n-1,:)-p.PYdr_iHVA_PYdr_B12_EHVA))))+(((( -p.PYdr_iKCa_PYdr_B12_gKCa.*(PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(n-1,:))./(PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(n-1,:) + p.PYdr_iKCa_PYdr_B12_KD).*(PYdr_v(n-1,:)-p.PYdr_iKCa_PYdr_B12_EKCa))))+((-(( p.PYdr_iNaP_PYdr_B12_gNaP.*(( 1./(1 + exp(-(PYdr_v(n-1,:)+55.7)./7.7)))).^3.*(PYdr_v(n-1,:)-p.PYdr_iNaP_PYdr_B12_ENaP))))+(((( p.PYdr_iAR_PYdr_B12_gAR.*(( 1./(1 + exp((PYdr_v(n-1,:)+75)./4)))).*(PYdr_v(n-1,:)-p.PYdr_iAR_PYdr_B12_EAR))))+(((( -p.PYdr_PYso_iCOM_PYdr_PYso_B12_gCOM.*(PYdr_v(n-1,:)-PYso_v(n-1,:)))))+(((( -p.PYdr_PYso_iAMPA_PYdr_PYso_B12_gAMPA/PYdr_PYso_iAMPA_PYdr_PYso_B12_normalizingFactor.*((PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:).*PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(n-1,:))*PYdr_PYso_iAMPA_PYdr_PYso_B12_netcon).*((PYdr_v(n-1,:))-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_EAMPA))))))))))))/p.PYdr_Cm;
  PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12_k1 = max(-p.PYdr_CaBuffer_PYdr_B12_alphaCa.*p.PYdr_CaBuffer_PYdr_B12_areaDR.*(((( p.PYdr_iHVA_PYdr_B12_gHVA.*(( 1./(1 + exp(-(PYdr_v(n-1,:)+20)./9)))).^2.*(PYdr_v(n-1,:)-p.PYdr_iHVA_PYdr_B12_EHVA))))), 0) - PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(n-1,:)./p.PYdr_CaBuffer_PYdr_B12_tauCa;
  PYso_v_k1 =((((( p.PYso_iAppliedCurrent_appliedStim*(t>p.PYso_iAppliedCurrent_onset & t<p.PYso_iAppliedCurrent_offset))))+(((( -p.PYso_iLeak_PYso_B12_gLeak.*(PYso_v(n-1,:)-p.PYso_iLeak_PYso_B12_ELeak))))+((-(( p.PYso_iNa_PYso_B12_gNa.*(( (( 0.1.*(PYso_v(n-1,:)+33)./(1-exp(-(PYso_v(n-1,:)+33)./10))))./((( 0.1.*(PYso_v(n-1,:)+33)./(1-exp(-(PYso_v(n-1,:)+33)./10)))) + ((  4.*exp(-(PYso_v(n-1,:)+53.7)./12)))))).^3.*PYso_iNa_PYso_B12_hNa(n-1,:).*(PYso_v(n-1,:)-p.PYso_iNa_PYso_B12_ENa))))+(((( p.PYso_iK_PYso_B12_gK.*PYso_iK_PYso_B12_nK(n-1,:).^4.*(PYso_v(n-1,:)-p.PYso_iK_PYso_B12_EK))))+(((( p.PYso_iA_PYso_B12_gA.*(( 1./(1 - exp(-(PYso_v(n-1,:)+50)./20)))).^3.*PYso_iA_PYso_B12_hA(n-1,:).*(PYso_v(n-1,:)-p.PYso_iA_PYso_B12_EA))))+(((( p.PYso_iKS_PYso_B12_gKS.*PYso_iKS_PYso_B12_mKS(n-1,:).^3.*(PYso_v(n-1,:)-p.PYso_iKS_PYso_B12_EKS))))+(((( -p.PYso_PYdr_iCOM_PYso_PYdr_B12_gCOM.*(PYso_v(n-1,:)-PYdr_v(n-1,:)))))+(((( -p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gKNa.*(0.37./(1 + (38.7./PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n-1,:)).^3.5))*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_netcon.*(PYso_v(n-1,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_EKNa)))))))))))))/p.PYso_Cm;
  PYso_iNa_PYso_B12_hNa_k1 = p.PYso_iNa_PYso_B12_phi.*(((( 0.07.*exp(-(PYso_v(n-1,:)+50)./10))).*(1-PYso_iNa_PYso_B12_hNa(n-1,:))) - (((  1./(1+exp(-(PYso_v(n-1,:)+20)./10)))).*PYso_iNa_PYso_B12_hNa(n-1,:)));
  PYso_iK_PYso_B12_nK_k1 = p.PYso_iK_PYso_B12_phi.*(((( 0.01.*(PYso_v(n-1,:)+34)./(1 - exp(-(PYso_v(n-1,:)+34)./10)))).*(1-PYso_iK_PYso_B12_nK(n-1,:))) - (((  0.125.*exp(-(PYso_v(n-1,:)+44)./25))).*PYso_iK_PYso_B12_nK(n-1,:)));
  PYso_iA_PYso_B12_hA_k1 = p.PYso_iA_PYso_B12_phi.*((( 1./(1 + exp((PYso_v(n-1,:)+80)./6)))) - PYso_iA_PYso_B12_hA(n-1,:))./p.PYso_iA_PYso_B12_tauH;
  PYso_iKS_PYso_B12_mKS_k1 = p.PYso_iKS_PYso_B12_phi.*((( 1./(1 + exp(-(PYso_v(n-1,:)+34)./6.5)))) - PYso_iKS_PYso_B12_mKS(n-1,:))./(( 8./(exp(-(PYso_v(n-1,:)+55)./30) + exp((PYso_v(n-1,:)+55)./30))));
  IN_v_k1 =((((( p.IN_iAppliedCurrent_appliedStim*(t>p.IN_iAppliedCurrent_onset & t<p.IN_iAppliedCurrent_offset))))+(((( -p.IN_iLeak_IN_B12_gLeak.*(IN_v(n-1,:)-p.IN_iLeak_IN_B12_ELeak))))+(((( -p.IN_iNa_IN_B12_gNa.*IN_iNa_IN_B12_mNa(n-1,:).^3.*IN_iNa_IN_B12_hNa(n-1,:).*(IN_v(n-1,:)-p.IN_iNa_IN_B12_ENa))))+(((( -p.IN_iK_IN_B12_gK.*IN_iK_IN_B12_nK(n-1,:).^4.*(IN_v(n-1,:)-p.IN_iK_IN_B12_EK)))))))))/p.IN_Cm;
  IN_iNa_IN_B12_mNa_k1 = ((( 0.5.*(IN_v(n-1,:)+35)./(1-exp(-(IN_v(n-1,:)+35)./10)))).*(1-IN_iNa_IN_B12_mNa(n-1,:))) - (((  20.*exp(-(IN_v(n-1,:)+60)./18))).*IN_iNa_IN_B12_mNa(n-1,:));
  IN_iNa_IN_B12_hNa_k1 = ((( 0.35.*exp(-(IN_v(n-1,:)+58)./20))).*(1-IN_iNa_IN_B12_hNa(n-1,:))) - (((  5./(1+exp(-(IN_v(n-1,:)+28)./10)))).*IN_iNa_IN_B12_hNa(n-1,:));
  IN_iK_IN_B12_nK_k1 = ((( 0.05.*(IN_v(n-1,:)+34)./(1 - exp(-(IN_v(n-1,:)+34)./10)))).*(1-IN_iK_IN_B12_nK(n-1,:))) - (((  0.625.*exp(-(IN_v(n-1,:)+44)./80))).*IN_iK_IN_B12_nK(n-1,:));
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa_k1 = p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_phi.*(((( 0.07.*exp(-(PYso_v(n-1,:)+50)./10))).*(1-PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n-1,:))) - (((  1./(1+exp(-(PYso_v(n-1,:)+20)./10)))).*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n-1,:)));
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa_k1 = -p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_alphaNa.*(0.00015.*(( -p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNa.*(( (( 0.1.*(PYso_v(n-1,:)+33)./(1-exp(-(PYso_v(n-1,:)+33)./10))))./((( 0.1.*(PYso_v(n-1,:)+33)./(1-exp(-(PYso_v(n-1,:)+33)./10)))) + ((  4.*exp(-(PYso_v(n-1,:)+53.7)./12)))))).^3.*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n-1,:).*(PYso_v(n-1,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENa))) + 0.00035.*(( -p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNaP.*(( 1./(1 + exp(-((PYdr_v(n-1,:))+55.7)./7.7)))).^3.*((PYdr_v(n-1,:))-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENaP)))) - p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_RPump.*(PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n-1,:).^3./(PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n-1,:).^3+15^3) - PYso_PYdr_iNaCurrs_PYso_PYdr_B12_eqNaPumpTerm);
  PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA_k1 = p.PYdr_PYso_iAMPA_PYdr_PYso_B12_alpha./(1 + exp(-(PYso_v(n-1,:)-20)./2)) - PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(n-1,:)./p.PYdr_PYso_iAMPA_PYdr_PYso_B12_tauS;
  PYdr_PYso_iAMPA_PYdr_PYso_B12_res_k1 = (1 - PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:))./p.PYdr_PYso_iAMPA_PYdr_PYso_B12_tauRes + ((t-PYso_tspike)<=dt).*(-(1 - PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:))./p.PYdr_PYso_iAMPA_PYdr_PYso_B12_tauRes + (p.PYdr_PYso_iAMPA_PYdr_PYso_B12_deprFactor.*PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:) - PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:))./dt);

  % ------------------------------------------------------------
  % Update state variables:
  % ------------------------------------------------------------
  PYdr_v(n,:) = PYdr_v(n-1,:)+dt*PYdr_v_k1;
  PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(n,:) = PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12(n-1,:)+dt*PYdr_CaBuffer_PYdr_B12_CaBuffer_PYdr_B12_k1;
  PYso_v(n,:) = PYso_v(n-1,:)+dt*PYso_v_k1;
  PYso_iNa_PYso_B12_hNa(n,:) = PYso_iNa_PYso_B12_hNa(n-1,:)+dt*PYso_iNa_PYso_B12_hNa_k1;
  PYso_iK_PYso_B12_nK(n,:) = PYso_iK_PYso_B12_nK(n-1,:)+dt*PYso_iK_PYso_B12_nK_k1;
  PYso_iA_PYso_B12_hA(n,:) = PYso_iA_PYso_B12_hA(n-1,:)+dt*PYso_iA_PYso_B12_hA_k1;
  PYso_iKS_PYso_B12_mKS(n,:) = PYso_iKS_PYso_B12_mKS(n-1,:)+dt*PYso_iKS_PYso_B12_mKS_k1;
  IN_v(n,:) = IN_v(n-1,:)+dt*IN_v_k1;
  IN_iNa_IN_B12_mNa(n,:) = IN_iNa_IN_B12_mNa(n-1,:)+dt*IN_iNa_IN_B12_mNa_k1;
  IN_iNa_IN_B12_hNa(n,:) = IN_iNa_IN_B12_hNa(n-1,:)+dt*IN_iNa_IN_B12_hNa_k1;
  IN_iK_IN_B12_nK(n,:) = IN_iK_IN_B12_nK(n-1,:)+dt*IN_iK_IN_B12_nK_k1;
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n,:) = PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n-1,:)+dt*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa_k1;
  PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n,:) = PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n-1,:)+dt*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa_k1;
  PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(n,:) = PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(n-1,:)+dt*PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA_k1;
  PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n,:) = PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n-1,:)+dt*PYdr_PYso_iAMPA_PYdr_PYso_B12_res_k1;

  % ------------------------------------------------------------
  % Conditional actions:
  % ------------------------------------------------------------
  conditional_test=(IN_v(n,:)>=p.IN_spike_threshold&IN_v(n-1,:)<p.IN_spike_threshold);
  if ~exist('IN_v_spikes','var')
    IN_v_spikes = [];
  end;
  if any(conditional_test), IN_v_spikes(n,conditional_test)=1;inds=find(conditional_test); for j=1:length(inds), i=inds(j); IN_tspike(IN_buffer_index(i),i)=t; IN_buffer_index(i)=mod(-1+(IN_buffer_index(i)+1),1)+1; end; end
  conditional_test=(PYso_v(n,:)>=p.PYso_spike_threshold&PYso_v(n-1,:)<p.PYso_spike_threshold);
  if ~exist('PYso_v_spikes','var')
    PYso_v_spikes = [];
  end;
  if any(conditional_test), PYso_v_spikes(n,conditional_test)=1;inds=find(conditional_test); for j=1:length(inds), i=inds(j); PYso_tspike(PYso_buffer_index(i),i)=t; PYso_buffer_index(i)=mod(-1+(PYso_buffer_index(i)+1),1)+1; end; end
  conditional_test=(PYdr_v(n,:)>=p.PYdr_spike_threshold&PYdr_v(n-1,:)<p.PYdr_spike_threshold);
  if ~exist('PYdr_v_spikes','var')
    PYdr_v_spikes = [];
  end;
  if any(conditional_test), PYdr_v_spikes(n,conditional_test)=1;inds=find(conditional_test); for j=1:length(inds), i=inds(j); PYdr_tspike(PYdr_buffer_index(i),i)=t; PYdr_buffer_index(i)=mod(-1+(PYdr_buffer_index(i)+1),1)+1; end; end

  % ------------------------------------------------------------
  % Update monitors:
  % ------------------------------------------------------------
    PYdr_iHVA_PYdr_B12_IHVA_PYdr_B12(n,:) =p.PYdr_iHVA_PYdr_B12_gHVA.*(( 1./(1 + exp(-(PYdr_v(n,:)+20)./9)))).^2.*(PYdr_v(n,:)-p.PYdr_iHVA_PYdr_B12_EHVA);
    PYdr_iNaP_PYdr_B12_INaP_PYdr_B12(n,:) =p.PYdr_iNaP_PYdr_B12_gNaP.*(( 1./(1 + exp(-(PYdr_v(n,:)+55.7)./7.7)))).^3.*(PYdr_v(n,:)-p.PYdr_iNaP_PYdr_B12_ENaP);
    PYdr_iAR_PYdr_B12_IAR_PYdr_B12(n,:) =p.PYdr_iAR_PYdr_B12_gAR.*(( 1./(1 + exp((PYdr_v(n,:)+75)./4)))).*(PYdr_v(n,:)-p.PYdr_iAR_PYdr_B12_EAR);
    PYso_iLeak_PYso_B12_ILeak_PYso_B12(n,:) =-p.PYso_iLeak_PYso_B12_gLeak.*(PYso_v(n,:)-p.PYso_iLeak_PYso_B12_ELeak);
    PYso_iNa_PYso_B12_INa_PYso_B12(n,:) =p.PYso_iNa_PYso_B12_gNa.*(( (( 0.1.*(PYso_v(n,:)+33)./(1-exp(-(PYso_v(n,:)+33)./10))))./((( 0.1.*(PYso_v(n,:)+33)./(1-exp(-(PYso_v(n,:)+33)./10)))) + ((  4.*exp(-(PYso_v(n,:)+53.7)./12)))))).^3.*PYso_iNa_PYso_B12_hNa(n,:).*(PYso_v(n,:)-p.PYso_iNa_PYso_B12_ENa);
    PYso_iK_PYso_B12_IK_PYso_B12(n,:) =p.PYso_iK_PYso_B12_gK.*PYso_iK_PYso_B12_nK(n,:).^4.*(PYso_v(n,:)-p.PYso_iK_PYso_B12_EK);
    PYso_iA_PYso_B12_IA_PYso_B12(n,:) =p.PYso_iA_PYso_B12_gA.*(( 1./(1 - exp(-(PYso_v(n,:)+50)./20)))).^3.*PYso_iA_PYso_B12_hA(n,:).*(PYso_v(n,:)-p.PYso_iA_PYso_B12_EA);
    PYso_iKS_PYso_B12_IKS_PYso_B12(n,:) =p.PYso_iKS_PYso_B12_gKS.*PYso_iKS_PYso_B12_mKS(n,:).^3.*(PYso_v(n,:)-p.PYso_iKS_PYso_B12_EKS);
    IN_iLeak_IN_B12_ILeak_IN_B12(n,:) =-p.IN_iLeak_IN_B12_gLeak.*(IN_v(n,:)-p.IN_iLeak_IN_B12_ELeak);
    IN_iNa_IN_B12_INa_IN_B12(n,:) =-p.IN_iNa_IN_B12_gNa.*IN_iNa_IN_B12_mNa(n,:).^3.*IN_iNa_IN_B12_hNa(n,:).*(IN_v(n,:)-p.IN_iNa_IN_B12_ENa);
    IN_iK_IN_B12_IK_IN_B12(n,:) =-p.IN_iK_IN_B12_gK.*IN_iK_IN_B12_nK(n,:).^4.*(IN_v(n,:)-p.IN_iK_IN_B12_EK);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INa_PYso_local(n,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNa.*(( (( 0.1.*(PYso_v(n,:)+33)./(1-exp(-(PYso_v(n,:)+33)./10))))./((( 0.1.*(PYso_v(n,:)+33)./(1-exp(-(PYso_v(n,:)+33)./10)))) + ((  4.*exp(-(PYso_v(n,:)+53.7)./12)))))).^3.*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_hNa(n,:).*(PYso_v(n,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENa);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_INaP_PYdr_local(n,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gNaP.*(( 1./(1 + exp(-(PYso_v(n,:)+55.7)./7.7)))).^3.*(PYso_v(n,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_ENaP);
    PYso_PYdr_iNaCurrs_PYso_PYdr_B12_IKNa_PYso_PYdr_B12(n,:) =-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_gKNa.*(0.37./(1 + (38.7./PYso_PYdr_iNaCurrs_PYso_PYdr_B12_concNa(n,:)).^3.5))*PYso_PYdr_iNaCurrs_PYso_PYdr_B12_netcon.*(PYso_v(n,:)-p.PYso_PYdr_iNaCurrs_PYso_PYdr_B12_EKNa);
    PYdr_PYso_iAMPA_PYdr_PYso_B12_IAMPA_PYdr_PYso_B12(n,:) =-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_gAMPA/PYdr_PYso_iAMPA_PYdr_PYso_B12_normalizingFactor.*((PYdr_PYso_iAMPA_PYdr_PYso_B12_res(n,:).*PYdr_PYso_iAMPA_PYdr_PYso_B12_sAMPA(n,:))*PYdr_PYso_iAMPA_PYdr_PYso_B12_netcon).*(PYdr_v(n,:)-p.PYdr_PYso_iAMPA_PYdr_PYso_B12_EAMPA);
  n=n+1;
end

T=T(1:downsample_factor:ntime);

end

