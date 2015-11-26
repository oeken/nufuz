clc;
clear;

scale = 0.15;
% cards_base = '/img/allcards_high/';
% cards = '/img/allcards_high/*.jpg';
% cards_target = '/img_processed/cards/';

cards_base = '/img/cards_framed/';
cards = '/img/cards_framed/*.jpg';
cards_target = '/img_processed/cards_framed/';


gems_base = '/img/gems/';
gems = '/img/gems/*.jpg';
gems_target = '/img_processed/gems/';


mkdir(strcat(pwd,cards_target));
mkdir(strcat(pwd,gems_target));

card_images = dir(strcat(pwd,cards));
gem_images = dir(strcat(pwd,gems));

for i=1:length(card_images)
    name1 = card_images(i).name;
    name2 = strcat(strcat(pwd,cards_base) , name1);
    a = imread(name2);
    b =imresize(a,scale);
    
    
    target_name = strcat(strcat(pwd,cards_target) , name1);
    imwrite(b, target_name);
end

for i=1:length(gem_images)
    name1 = gem_images(i).name;
    name2 = strcat(strcat(pwd,gems_base) , name1);
    a = imread(name2);
    b =imresize(a,scale);
    
    
    target_name = strcat(strcat(pwd,gems_target) , name1);
    imwrite(b, target_name);
end





% strcat(pwd,cards);
% strcat(pwd,gems);
% imagefiles = dir(*.jpg);
% a = imread(filename);
% b = double(current_image);
% c =imresize(current_image,scale);
% imwrite(c, '')




