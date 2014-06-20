function quest1(image)

% Função da questão 1 da prova de PDI - mestrado ICOMP
% @author: Anderson Gadelha Fontoura
% @date: 19/06/2014
% 
% Inputs: image - imagem RGB ou grayscale
%
% Exemplo de uso: >>quest1('image1.jpg')
%
% Subfunctions: 
% 
% 1 - histequalizer: função de equalização do histograma em
% uma imagem 8 bits (0 - 255) 
%
% 2 - negative: função para aplicar um filtro negativo na imagem, ou seja,
% inverte os valores dentro da faixa de 0 a 255. P. e.: se um pixel vale
% 87, ele passar a ser ValorDoMaiorPixelNaImagem - 87. Se o valor do maior 
% pixel for 255, então: 255 - 87 = 168  
%
% 3 - imThreshold(imagem, thresh): recebe 2 argumentos: imagem = image a
% ser limiarizada; thresh = valor de limiarização. P. e.: se thresh for
% 191, todos os valores acima ou igual a 191 irão para 255 e os outros, vão
% para 0.
%

%% leitura da imagem

im = imread(image);
t = input('insira o limite de limiarização (0 - 255)\n');
t = double(t)/255;

%% normalizando a imagem sem o im2double

%im = double(im)/255;

%% ignorar -> apenas para images RGB puras e de canais separados
% imB = zeros(x,y);       %criando uma matriz de zeros do mesmo tamanho da imagem
% 
% % irá criar um filtro lógico
% for i = 1:x
%     for j = 1:y
%         if(sum(im(i,j,:)) > 0)
%             imB(i,j) = 1;
%         end
%     end
% end
% 
% imB = logical(imB);    %convertendo a matriz de inteiros para o valor lógico 0/1.

%% convertendo RGB para grayscale

gim = uint8(zeros(size(im,1),size(im,2)));

for i = 1:size(im,1)
    for j = 1:size(im,2)
        gim(i,j) = .299*im(i,j,1) + .587*im(i,j,2) + .114*im(i,j,3);
    end
end

% sem o uso do loop
% gim = .299*im(:,:,1) + .587*im(:,:,2) + .114*im(:,:,3);

%% aplicando o filtro negativo
gim = negative(gim); 

%% chamando a equalização do histograma sem o uso do histeq

%subfunção histequalizer
gim = int8(gim*255);
gim = histequalizer(gim);
gim = double(gim)/255;

%% Binarizando com Thresholding

gim = imThreshold(gim,t);

%% mostrando o resultado

subplot(1,2,1), subimage(im), title('Imagem original')
subplot(1,2,2), subimage(gim), title('Imagem binarizada')
imwrite(gim,'image1Binarizada.jpg');

end

%% função de equalização do histograma
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
        him(i,j) = output(im(i,j)+1);
    end
end

im2 = him;

end

%% função para o filtro negativo
function imN = negative(image)

im = image;
[m,n] = size(im);

%encontrando o maior valor de pixel
maiorp = max(max(im));
maiorp = double(maiorp)/255;  %apenas aumentando a precisão
im = double(im)/255;

%convertendo em negativo
for i = 1:m
    for j = 1:n
        im_neg(i,j) = maiorp-im(i,j);
    end
end

imN = im_neg;

end

%% função de limiarização simples
function imT = imThreshold(image, thresh)

t = thresh;
im = image;

[m,n] = size(im); 

for i = 1:m 
    for j = 1:n 
        if im(i,j) <= t          % valor do pixel menor ou igual que o thresh setado
            imB(i,j) = .0;       % valor do pixel vai para 0 - mais escuro fica a imagem
        else
            imB(i,j) = 1.0;      % Se for acima de thresh - valor do pixel vai para 1 (255) - mais clara fica a imagem
        end
    end
end

imT = imB;

end
