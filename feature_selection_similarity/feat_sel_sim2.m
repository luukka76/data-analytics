function [data_mod, index_rem]=feat_sel_sim(data, Emeasure, Smeasure, p)
%
% Feature selection method using similarity measure and fuzzy entropy 
% measures based on the articles:
%
% P. Luukka, (2011) Feature Selection Using Fuzzy Entropy Measures with
% Similarity Classifier, Expert Systems with Applications, 38, pp.
% 4600-4607
%
%
%This update also includes extension to Yu's similarity which was published
%in the article:
%C. Iyakaremye, P. Luukka, D. Koloseni, (2012) Feature selection using Yu's
%similarity measure and fuzzy entropy measures, IEEE International
%conference on Fuzzy Systems (FUZZ-IEEE), 2012, pages 1-6.

% Function call:
% [data_mod, index_rem]=feat_sel_sim(data, Emeasure, Smeasure, p)
%
% OUTPUTS:
% data_mod      data without removed feature
% index_rem     index of removed feature in original data
%
%INPUTS:
% data          data matrix, contains class values
% Emeasure       fuzzy entropy measure, either 'luca' or 'park' 
%               currently coded
% Smeasure      Similarity measure, either 1 or 2 
%               currently coded. 1 is for Lukasiewicz similarity and 2 for
%               similarity based on Yu's norms.
% p             parameter for the similarity measure if Smeasure is for 
%               Lukasiewicz similarity measure then
%               p in (0, \infty) as default p=1. If Smeasure is for Yu's
%               similarity then p in (0, \infty)
if nargin<4
   p=1;
end
if nargin<3
   Smeasure=1;
end
if nargin<2
    measure='luca'
end

l=max(data(:,end));     % #-classes
m=size(data,1);         % #-samples
t=size(data,2)-1;       % #-features
dataold=data;
tmp=[];
% forming idealvec using arithmetic mean
idealvec=zeros(l,t);
for k=1:l
    idealvec_s(k,:)=mean(data(find(data(:,end)==k),1:t));
end


%scaling data between [0,1]
data_v=data(:,1:t);
data_c=data(:,t+1); %labels
mins_v = min(data_v);
Ones = ones(size(data_v));
data_v = data_v+Ones*diag(abs(mins_v));
for k=1:l
    tmp=[tmp;abs(mins_v)];
end
tmp;
idealvec_s = idealvec_s+tmp;
maxs_v = max(data_v);
data_v = data_v*diag(maxs_v.^(-1));
idealvec_s=idealvec_s./repmat(maxs_v,l,1);
data = [data_v, data_c];
% sample data
datalearn_s=data(:,1:t);

% similarities
sim=zeros(t,m,l);

if Smeasure==1
    for j=1:m
        for i=1:t
            for k=1:l
                sim(i,j,k)=(1-abs(idealvec_s(k,i)^p-datalearn_s(j,i))^p)^(1/p);
            end
        end
    end
elseif Smeasure==2
    for j=1:m
        for i=1:t
            for k=1:l
                lambda=p;
                %T-conorms:
                sn1=min(1,1-datalearn_s(j,i)+idealvec_s(k,i)+lambda*(1-datalearn_s(j,i))*idealvec_s(k,i));
                sn2=min(1,datalearn_s(j,i)+1-idealvec_s(k,i)+lambda*(1-idealvec_s(k,i))*datalearn_s(j,i));
                %Similarity:
                sim(i,j,k)=max(0,(1+lambda)*(sn1+sn2-1)-lambda*sn1*sn2);
            end
        end
    end
end    
    
% reduce number of dimensions in sim
sim=reshape(sim,t,m*l)';

% possibility for two different entropy measures
if Emeasure=='luca'
% moodifying zero and one values of the similarity values to work with 
% De Luca's entropy measure
    delta=1E-10;
    sim(find(sim==0))=delta;
    sim(find(sim==1))=1-delta;
    H=sum(-sim.*log(sim)-(1-sim).*log(1-sim));
    
elseif Emeasure=='park'
    H=sum(sin(pi/2*sim)+sin(pi/2*(1-sim))-1);  
end

% find maximum feature
[i, index_rem]=max(H);

% removing feature from the data
data_mod=[dataold(:,1:index_rem-1) dataold(:,index_rem+1:end)];
j=1;
H
return
