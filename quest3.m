function quest3(image, filter)

% Função da questão 3 da prova de PDI - mestrado ICOMP
% @author: Anderson Gadelha Fontoura
% @date: 18/06/2014
% 
% Inputs: image - imagem RGB ou grayscale
%         filter - tipo de filtro a ser usado: 'gama', 'log' ou 'exp'
%
% Exemplo de uso: >>quest3('image3.jpg','gama')
%
% Subfunctions: 1 - histequalizer: função de equalização do histograma em
% uma imagem 8 bits (0 - 255)
%

%% leitura da imagem

im = imread(image);
[x,y] = size(im);

%% normalizando a imagem

im = double(im)/255;

%% convertendo a imagem para tons de cinza sem o rgb2gray

im = .299*im(:,:,1) + .587*im(:,:,2) + .114*im(:,:,3);

%% equalizando o histograma sem o uso do histeq

%subfunção histequalizer
im = int8(im*255);
im = histequalizer(im);
im = double(im)/255;

%% filtros gama, exponencial e logaritmo

[x,y] = size(im);

if(strcmp(filter,'gama'))
    gama = input('insira o fator gama\n'); 
    c = 1;
    for i = 1:x
        for j = 1:y
            im(i,j) = c*im(i,j)^gama;
        end
    end
elseif(strcmp(filter,'log'))
    c = 2;
    for i = 1:x
        for j = 1:y
            im(i,j) = c*log(1+im(i,j));
        end
    end
elseif(strcmp(filter,'alpha'))
    alpha = input('insira o fator alpha\n');
    c = 4;
    for i = 1:x
        for j = 1:y
            im(i,j) = c*(((1+alpha)^im(i,j))-1);
        end
    end
end

%% aplicando o filtro mediano

%Cria a matriz com zeros em todos os lados
imA=zeros(size(im)+2);
imB=zeros(size(im));

%Copia a matriz da imagem original para a matriz com zeros
for i = 1:size(im,1)
    for j = 1:size(im,2)
        imA(i+1,j+1)=im(i,j);
    end
end

%Criamos aqui um vetor chamado 'window' que irá guardar os valores 3-por-3 
%dos vizinhos do vetor 'sort' e depois encontra o elemento mediano
       
for i = 1:size(imA,1)-2
    for j = 1:size(imA,2)-2
        window = zeros(9,1);
        inc = 1;
        for a = 1:3
            for b = 1:3
                window(inc) = imA(i+a-1,j+b-1);
                inc = inc + 1;
            end
        end
       
        med = sort(window);
        
        %Coloca o elemento mediano na matriz de saída
        
        imB(i,j) = med(5);
       
    end
end

%% mostrando o resultado

imshow(imB);

end

function im2 = histequalizer(im)

npixels = size(im,1) * size(im,2);
him = uint8(zeros(size(im,1),size(im,2)));
freq = zeros(256,1);
probf = zeros(256,1);
probc = zeros(256,1);
cum = zeros(256,1);
output = zeros(256,1);

%freq conta a ocorrência dos valores de cada pixel, ou seja, se pixel_1, 2 e 3 possuem o mesmo valor a freq = 3
%A probabilidade de cada ocorrência e calculada pela probf.

for i = 1:size(im,1)
    for j = 1:size(im,2)
        value = im(i,j);
        freq(value+1) = freq(value+1) + 1;
        probf(value+1) = freq(value+1)/npixels;
    end
end

sum=0;
no_bins=255;

%A probabilidade da distribuição acumulativa é calculada. 

for i = 1:size(probf)
   sum = sum + freq(i);
   cum(i) = sum;
   probc(i) = cum(i)/npixels;
   output(i) = round(probc(i)*no_bins);
end

for i = 1:size(im,1)
    for j = 1:size(im,2)
        him(i,j)=output(im(i,j)+1);
    end
end

im2 = him;

end

%% reposta da imagem

%pessoas = 21
%homens = 9
%mulheres = 12
%bermuda = 16
%calça = 5
%em pé = 15
%sentados = 6
