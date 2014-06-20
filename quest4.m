function quest4(image)

% Função da questão 4 da prova de PDI - mestrado ICOMP
% @author: Anderson Gadelha Fontoura
% @date: 19/06/2014
% 
% Inputs: image - imagem RGB ou grayscale
%
% Exemplo de uso: >>quest4('image4.jpg')
%
% Subfunctions: 
% 
% 1 - zoomBilinear: função de zoom com o método bilinear  
%
% 2 - zoomBicubic: função de zoom com o método bicúbico
%

%% leitura da imagem

im = imread(image);             %lê o tamanho da imagem
%[x,y] = size(im);

%% normalizando a imagem sem o im2double

im = double(im)/255;

%% convertendo a imagem para tons de cinza sem o rgb2gray

im = .299*im(:,:,1) + .587*im(:,:,2) + .114*im(:,:,3);

%% removendo apenas a clareira (metódo manual)

clra = im(1:120,270:320);

%clra = zeros(120,50);          %cria a matriz clra de 0's
%for a = 270:1:320
%   for b = 1:1:120
%      clra(b,a) = im(b,a);
%   end
%end

%% Aplicando o Zoom

imB = zoomBilinear(clra,4);
imC = zoomBicubic(clra,4);

%% resultados

subplot(2,2,1), subimage(im), title('Imagem original em tons de cinza')
subplot(2,2,2), subimage(clra), title('Imagem da clareira 120x50')
subplot(2,2,3), subimage(imB), title('Imagem da clareira zoom bilinear')
subplot(2,2,4), subimage(imC), title('Imagem da clareira zoom bicúbico')

end

% function imz = zoomBilinear(image,zoom)
% 
%     [x,y,z] = size(image);
%     
%     zx = zoom*x;              %ampliando as linhas
%     zy = zoom*y;              %ampliando as colunas
% 
%     for i=1:zx
% 
%         x=i/zoom;
% 
%         x1=floor(x);        %arredonda pra baixo
%         x2=ceil(x);         %arredonda pra cima
%         
%         if x1 == 0
%             x1 = 1;
%         end
%         
%         xint = rem(x,1);      %igual a funçao mod
%         
%         for j=1:zy
% 
%             y=j/zoom;
% 
%             y1=floor(y);
%             y2=ceil(y);
%             
%             if y1==0
%                 y1=1;
%             end
%             
%             yint=rem(y,1);
% 
%             %fazendo a interpolação Bilinear
%             
%             BotL=image(x1,y1,:);
%             TopL=image(x1,y2,:);
%             BotR=image(x2,y1,:);
%             TopR=image(x2,y2,:);
% 
%             R1=BotR*yint+BotL*(1-yint);
%             R2=TopR*yint+TopL*(1-yint);
% 
%             imZoom(i,j,:)=R1*xint+R2*(1-xint);
%         end
%     end
%     
%     imz = imZoom;
%     
% end

%% função de zoom bilinear
function imB = zoomBilinear(image,zoom)

[r, c, d] = size(image);
rn = floor(zoom*r);             %arrendonda para baixo - determina o tamanho do Zoom de linhas
cn = floor(zoom*c);             %arrendonda para baixo - determina o tamanho do Zoom de colunas
s = zoom;

for i = 1:rn;
    x1 = floor(i/s);
    x2 = ceil(i/s);
    if x1 == 0
        x1 = 1;
    end
    x = rem(i/s,1);             %função igual ao mod
    for j = 1:cn;
        y1 = floor(j/s);
        y2 = ceil(j/s);
        if y1 == 0
            y1 = 1;
        end
        ctl = image(x1,y1,:);
        cbl = image(x2,y1,:);
        ctr = image(x1,y2,:);
        cbr = image(x2,y2,:);
        y = rem(j/s,1);
        tr = (ctr*y)+(ctl*(1-y));
        br = (cbr*y)+(cbl*(1-y));
        im_zoom(i,j,:) = (br*x)+(tr*(1-x));
    end
end

imB = im_zoom;

end

%% função de zoom bicúbica

function imC = zoomBicubic(image,zoom)

[r,c,d] = size(image);
rn = floor(zoom*r);
cn = floor(zoom*c);
s = zoom;

im_pad = zeros(r+4,c+4,d);      %cria um matriz de zeros
im_pad(2:r+1,2:c+1,:) = image;

for m = 1:rn
    
    x1 = ceil(m/s); 
    x2 = x1+1; 
    x3 = x2+1;
    p = x1;
    
    if(s>1)
       m1 = ceil(s*(x1-1));
       m2 = ceil(s*(x1));
       m3 = ceil(s*(x2));
       m4 = ceil(s*(x3));
    else
       m1 = (s*(x1-1));
       m2 = (s*(x1));
       m3 = (s*(x2));
       m4 = (s*(x3));
    end
    X = [ (m-m2)*(m-m3)*(m-m4)/((m1-m2)*(m1-m3)*(m1-m4)) ...
          (m-m1)*(m-m3)*(m-m4)/((m2-m1)*(m2-m3)*(m2-m4)) ...
          (m-m1)*(m-m2)*(m-m4)/((m3-m1)*(m3-m2)*(m3-m4)) ...
          (m-m1)*(m-m2)*(m-m3)/((m4-m1)*(m4-m2)*(m4-m3))];
    for n = 1:cn
        
        y1 = ceil(n/s); 
        y2 = y1+1; 
        y3 = y2+1;
        
        if (s>1)
           n1 = ceil(s*(y1-1));
           n2 = ceil(s*(y1));
           n3 = ceil(s*(y2));
           n4 = ceil(s*(y3));
        else
           n1 = (s*(y1-1));
           n2 = (s*(y1));
           n3 = (s*(y2));
           n4 = (s*(y3));
        end
        Y = [ (n-n2)*(n-n3)*(n-n4)/((n1-n2)*(n1-n3)*(n1-n4));...
              (n-n1)*(n-n3)*(n-n4)/((n2-n1)*(n2-n3)*(n2-n4));...
              (n-n1)*(n-n2)*(n-n4)/((n3-n1)*(n3-n2)*(n3-n4));...
              (n-n1)*(n-n2)*(n-n3)/((n4-n1)*(n4-n2)*(n4-n3))];
        
        q = y1;
        
        sample = im_pad(p:p+3,q:q+3,:);
        im_zoom(m,n,1) = X*sample(:,:,1)*Y;
        if(d~=1)
              im_zoom(m,n,2) = X*sample(:,:,2)*Y;
              im_zoom(m,n,3) = X*sample(:,:,3)*Y;
        end
    end
end
imC = im_zoom;
end
