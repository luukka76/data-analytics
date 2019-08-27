function [output,other]=FullSupDispTable(data,filename,sheet) 

%no additional functions or m-files are needed
%Inputs: 
%- data: n x 2 matrix. First column has membership degrees to A and second to B
%- filename: deired name of the excel file with outputs
%- sheet: number of the shhet in the given file where the outputs should be saved
%
%Outputs: a degree-of-suport and degree-of-disproof table as presented in
%Stoklasa, J., Luukka, P., & Talášek, T. (2017). Set-theoretic methodology
%using fuzzy sets in rule extraction and validation - consistency and
%coverage revisited. Information Sciences, 412-413, 154–173.
%http://doi.org/10.1016/j.ins.2017.05.042, table 6 - this table is saved in
%the specified xlsx file
%- output: 11 x 2 matrix of the degree-of-support and degree-of-disproof values for alpha from 1 to 0 by 0.1
%- other: a 2 x 6 vector [Consistency1, Coverage1, Consistency2, Coverage2, Consistency3, Coverage3;
%    NConsistency1, NCoverage1, NConsistency2, NCoverage2, NConsistency3,
%    NCoverage3] - first row consistencies and coverages of A=>B, second
%    row for A=>B'
%

% call example: 
% data=[0.7000    0.9000;    0.1000    0.9000;    0.1000    0.1000; 0.3000    0.3000;    0.9000    0.9000;    0.7000    0.7000;  0.3000  0.9000;    0.3000    0.7000;    0.3000    0.7000;    0.1000    0.1000; 0         0;    0.9000    1.0000]
% [output,other]=FullSupDispTable(data,'file.xlsx',1)

%
%
% Created by Jan Stoklasa and Pasi Luukka, 08/2017


A=data(:,1);
B=data(:,2);
Bp=1-B;
[n,m] = size(data);

[Consistency1, Coverage1]=concov(data); %computes standard Ragin`s consistency and coverage for A=>B (F_1 in Stoklasa et al. (2017))
[NConsistency1, NCoverage1]=concov([A,Bp]); %computes standard Ragin`s consistency and coverage for A=>B' (F_1 in Stoklasa et al. (2017))
[Consistency2, Coverage2]=fconsistency2(data); %computes F_2 consistency and coverage for A=>B (Stoklasa et al. (2017))
[NConsistency2, NCoverage2]=fconsistency2([A,Bp]); %computes F_2 consistency and coverage for A=>B' (Stoklasa et al. (2017))
[Consistency3, Coverage3]=fconsistency(data); %computes F_3 consistency and coverage for A=>B (Stoklasa et al. (2017))
[NConsistency3, NCoverage3]=fconsistency([A,Bp]); %computes F_3 consistency and coverage for A=>B' (Stoklasa et al. (2017))

support=[];
disproof=[];
for i=1:-0.1:0
alpha=i;
    [~,supalpha]=suplevel(data,alpha);
[~,dispalpha]=displevel(data,alpha);
support=[support;supalpha];
disproof=[disproof;dispalpha];
end

output=[support,disproof];
other=[Consistency1, Coverage1, Consistency2, Coverage2, Consistency3, Coverage3;
    NConsistency1, NCoverage1, NConsistency2, NCoverage2, NConsistency3, NCoverage3];

Asup=0;
Adisp=0;
for j=1:1:11
    if (Asup==0)&&(output(j,1)>0)
        Asup=1-((j-1)/10);
    end
     if (Adisp==0)&&(output(j,2)>0)
        Adisp=1-((j-1)/10);
     end
end


Labels1={'F1 consistency', 'F1 coverage', 'F2 consistency', 'F2 coverage', 'F3 consistency', 'F3 coverage'};
xlswrite(filename,Labels1,sheet,'B1');
xlswrite(filename,{'A=>B'},sheet,'A2');
xlswrite(filename,{'A=>notB'},sheet,'A3');
xlswrite(filename,other,sheet,'B2');

xlswrite(filename,{'SUP1(A=>B) ='},sheet,'A6');
xlswrite(filename,{'SUP0.9(A=>B) ='},sheet,'A7');
xlswrite(filename,{'SUP0.8(A=>B) ='},sheet,'A8');
xlswrite(filename,{'SUP0.7(A=>B) ='},sheet,'A9');
xlswrite(filename,{'SUP0.6(A=>B) ='},sheet,'A10');
xlswrite(filename,{'SUP0.5(A=>B) ='},sheet,'A11');
xlswrite(filename,{'SUP0.4(A=>B) ='},sheet,'A12');
xlswrite(filename,{'SUP0.3(A=>B) ='},sheet,'A13');
xlswrite(filename,{'SUP0.2(A=>B) ='},sheet,'A14');
xlswrite(filename,{'SUP0.1(A=>B) ='},sheet,'A15');
xlswrite(filename,{'SUP0.0(A=>B) ='},sheet,'A16');
xlswrite(filename,{'alpha-SUP ='},sheet,'A18');
xlswrite(filename,output(:,1),sheet,'B6');
xlswrite(filename,Asup,sheet,'B18');

xlswrite(filename,{'DISP1(A=>B) ='},sheet,'C6');
xlswrite(filename,{'DISP0.9(A=>B) ='},sheet,'C7');
xlswrite(filename,{'DISP0.8(A=>B) ='},sheet,'C8');
xlswrite(filename,{'DISP0.7(A=>B) ='},sheet,'C9');
xlswrite(filename,{'DISP0.6(A=>B) ='},sheet,'C10');
xlswrite(filename,{'DISP0.5(A=>B) ='},sheet,'C11');
xlswrite(filename,{'DISP0.4(A=>B) ='},sheet,'C12');
xlswrite(filename,{'DISP0.3(A=>B) ='},sheet,'C13');
xlswrite(filename,{'DISP0.2(A=>B) ='},sheet,'C14');
xlswrite(filename,{'DISP0.1(A=>B) ='},sheet,'C15');
xlswrite(filename,{'DISP0.0(A=>B) ='},sheet,'C16');
xlswrite(filename,{'alpha-DISP ='},sheet,'C18');
xlswrite(filename,output(:,2),sheet,'D6');
xlswrite(filename,Adisp,sheet,'D18');
%assessing how much of the data set is used to generate the results (in terms of relative cardinality of A)
xlswrite(filename,{'Card(A)/n ='},sheet,'F18');
xlswrite(filename,sum(A)/n,sheet,'G18');%n is the number of data points in the sample (the number of rows in 'data')

xlswrite(filename,{'refer to:'},sheet,'A20');
xlswrite(filename,{'Stoklasa, J., Luukka, P. & Talášek, T. (2017). Set-theoretic methodology using fuzzy sets in rule extraction and validation - consistency and coverage revisited.'},sheet,'A21');
xlswrite(filename,{'Information Sciences, 412-413, p. 154–173. http://doi.org/10.1016/j.ins.2017.05.042'},sheet,'A22');
end

%% internal functions needed for the calculations
function [Consistency, Coverage]=concov(data)
%Inputs: data by n x 2 matrix. First column has membershipdegrees to A and
%second to B.
%Outputs: Consistency and Coverage values (Ragin)

A=data(:,1);
B=data(:,2);
intersection=min([A,B],[],2);
Consistency=sum(intersection)/sum(A);
Coverage=sum(intersection)/sum(B);
end

function [Con,Cov]=fconsistency(data)
%Inputs: data by n x 2 matrix. First column has membershipdegrees to A and
%second to B.
%Outputs: Consistency and Coverage F3 from Stoklasa et al. (2017).
%
A=data(:,1);
B=data(:,2);
Bc=1-data(:,2);

% i1=sum(min([A,B],[],2))/sum(A);
% i2=sum(min([A,Bc],[],2))/sum(A);
% 
% Con=i1-i2

tmp1=min([A,B],[],2);
tmp2=min([A,Bc],[],2);
num=tmp1-tmp2;
Con=max([0,sum(num)/sum(A)]); %Gives the same as previous
Cov=max([0,sum(num)/sum(B)]); %Coverage
end

function [Con,Cov]=fconsistency2(data)
%Inputs: data by n x 2 matrix. First column has membershipdegrees to A and
%second to B.
%Outputs: Consistency and Coverage F2 from Stoklasa et al. (2017).
%
A=data(:,1);
B=data(:,2);
Bc=1-data(:,2);


tmp1=min([A,B],[],2);
tmp2=min([A,B,Bc],[],2);
num=tmp1-tmp2;
Con=sum(num)/sum(A); %Gives the same as previous
Cov=sum(num)/sum(B); %Coverage
end

function [sup1,supalpha]=suplevel(data,alpha)
%Inputs:
%data: n x 2 matrix where membership degrees for sets A and B are given (between (0,1])
%alpha: required level of support alpha \in (0,1] 
%Outputs:
%sup1: alpha=1 support
%supalpha: support level for alpha

A=data(:,1);
B=data(:,2);

B1=(B==1);
Balpha=(B>=alpha);
intersection1=min([A,B1],[],2);
intersectionalpha=min([A,Balpha],[],2);
sup1=sum(intersection1)/sum(A);
supalpha=sum(intersectionalpha)/sum(A);
end

function [disp1,dispalpha]=displevel(data,alpha)
%Inputs:
%data: n x 2 matrix where membership degrees for sets A and B are given (between (0,1])
%alpha: required level of support alpha \in (0,1] 
%Outputs:
%disp1: alpha=1 disproof
%dispalpha: disproof level for alpha
A=data(:,1);
B=data(:,2);

Bp=1-B;

%for i=1:length(B)
B1=(Bp==1);
Balpha=(Bp>=alpha);
intersection1=min([A,B1],[],2);
intersectionalpha=min([A,Balpha],[],2);
disp1=sum(intersection1)/sum(A);
dispalpha=sum(intersectionalpha)/sum(A);
end