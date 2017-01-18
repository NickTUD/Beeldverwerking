function [character] = getCharacter(binaryImage)
    char_0 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_0.png'))));
    char_1 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_1.png'))));
    char_2 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_2.png'))));
    char_3 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_3.png'))));
    char_4 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_4.png'))));
    char_5 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_5.png'))));
    char_6 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_6.png'))));
    char_7 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_7.png'))));
    char_8 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_8.png'))));
    char_9 = logical(rgb2gray(imread(strcat('..\Resources\Images\char_9.png'))));
    char_a = logical(rgb2gray(imread(strcat('..\Resources\Images\char_a.png'))));
    char_b = logical(rgb2gray(imread(strcat('..\Resources\Images\char_b.png'))));
    char_c = logical(rgb2gray(imread(strcat('..\Resources\Images\char_c.png'))));
    char_d = logical(rgb2gray(imread(strcat('..\Resources\Images\char_d.png'))));
    char_e = logical(rgb2gray(imread(strcat('..\Resources\Images\char_e.png'))));
    char_f = logical(rgb2gray(imread(strcat('..\Resources\Images\char_f.png'))));
    char_g = logical(rgb2gray(imread(strcat('..\Resources\Images\char_g.png'))));
    char_h = logical(rgb2gray(imread(strcat('..\Resources\Images\char_h.png'))));
    char_i = logical(rgb2gray(imread(strcat('..\Resources\Images\char_i.png'))));
    char_j = logical(rgb2gray(imread(strcat('..\Resources\Images\char_j.png'))));
    char_k = logical(rgb2gray(imread(strcat('..\Resources\Images\char_k.png'))));
    char_l = logical(rgb2gray(imread(strcat('..\Resources\Images\char_l.png'))));
    char_m = logical(rgb2gray(imread(strcat('..\Resources\Images\char_m.png'))));
    char_n = logical(rgb2gray(imread(strcat('..\Resources\Images\char_n.png'))));
    char_o = logical(rgb2gray(imread(strcat('..\Resources\Images\char_o.png'))));
    char_p = logical(rgb2gray(imread(strcat('..\Resources\Images\char_p.png'))));
    char_q = logical(rgb2gray(imread(strcat('..\Resources\Images\char_q.png'))));
    char_r = logical(rgb2gray(imread(strcat('..\Resources\Images\char_r.png'))));
    char_s = logical(rgb2gray(imread(strcat('..\Resources\Images\char_s.png'))));
    char_t = logical(rgb2gray(imread(strcat('..\Resources\Images\char_t.png'))));
    char_u = logical(rgb2gray(imread(strcat('..\Resources\Images\char_u.png'))));
    char_v = logical(rgb2gray(imread(strcat('..\Resources\Images\char_v.png'))));
    char_w = logical(rgb2gray(imread(strcat('..\Resources\Images\char_w.png'))));
    char_x = logical(rgb2gray(imread(strcat('..\Resources\Images\char_x.png'))));
    char_y = logical(rgb2gray(imread(strcat('..\Resources\Images\char_y.png'))));
    char_z = logical(rgb2gray(imread(strcat('..\Resources\Images\char_z.png'))));
    cellArray = cell([1,36]);
    cellArray{1} = char_0;
    cellArray{2} = char_1;
    cellArray{3} = char_2;
    cellArray{4} = char_3;
    cellArray{5} = char_4;
    cellArray{6} = char_5;
    cellArray{7} = char_6;
    cellArray{8} = char_7;
    cellArray{9} = char_8;
    cellArray{10} = char_9;
    cellArray{11} = char_a;
    cellArray{12} = char_b;
    cellArray{13} = char_c;
    cellArray{14} = char_d;
    cellArray{15} = char_e;
    cellArray{16} = char_f;
    cellArray{17} = char_g;
    cellArray{18} = char_h;
    cellArray{19} = char_i;
    cellArray{20} = char_j;
    cellArray{21} = char_k;
    cellArray{22} = char_l;
    cellArray{23} = char_m;
    cellArray{24} = char_n;
    cellArray{25} = char_o;
    cellArray{26} = char_p;
    cellArray{27} = char_q;
    cellArray{28} = char_r;
    cellArray{29} = char_s;
    cellArray{30} = char_t;
    cellArray{31} = char_u;
    cellArray{32} = char_v;
    cellArray{33} = char_w;
    cellArray{34} = char_x;
    cellArray{35} = char_y;
    cellArray{36} = char_z;
    count = zeros(1,36);
    for i = 1:36
        image = abs(binaryImage - cellArray{i});
        count(i) = sum(sum(image)); 
    end
    [~,index] = max(count);
    character = Map(index);
end

