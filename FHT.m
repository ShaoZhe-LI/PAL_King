% =========================================================================
% INTRODUCTION
%	- Implement the miu-order Hankel transformation on the columns of the 
%       input matrix h
% -------------------------------------------------------------------------
% INPUT
%	h   		- target matrix (matrix before transformation)
%	N           - number of transformation points (the rows of the target matrix)
%	Nz          - number of transformations (the columns of the target matrix)
%	Nh          - truncation length of h
%	NH          - truncation length of H
%	alpha       - exponential coefficients of geometric series
%	x0      	- first element of x1
%   x1          - normalized sampling points' coordinates in \rho direction
%	k0      	- interpolation coefficient
%	miu      	- order of transformation
% OUTPUT
%	H           - matrix after transformation
% =========================================================================

function H=FHT(h,N,Nz,Nh,NH,alpha,x0,x1,k0,miu)
Nf=Nh*NH;
h1=h(1:end-1,:)./((x1(1:end-1)).'.^(miu));h2=h(2:end,:)./((x1(2:end)).'.^(miu));
phi=zeros(2*N,Nz);
phi(1:N-1,:)=(h1-h2).*exp((miu+1)*alpha*([0:N-2]+1-N).');
phi(1,:)=k0*(h1(1,:)-h2(1,:))*exp((miu+1)*alpha*(1-N));
phi(N,:)=h(end,:);Phi=fft(phi);
jnn=Nf*x0*exp(alpha*([0:2*N-1]+1-N));jn0=(besselj(miu+1,jnn)).';
J=ifft(jn0*ones(1,Nz));
G=fft(Phi.*J);
H=G(1:N,:)./(Nf*x1.')*Nh^2;
end