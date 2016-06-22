function carpet = sierpinski(nLevels,classname)
if nargin == 1
    classname = 'single';
end

mSize = 3^nLevels;
carpet = ones(mSize,classname);

cutCarpet(1,1,mSize,nLevels) % begin recursion

    function cutCarpet(x,y,s,cL)
        if cL
            ss = s/3; % define subsize
            for lx = 0:2
                for ly = 0:2
                    if lx == 1 && ly == 1  
                        % remove center square
                        carpet(x+ss:x+2*ss-1,y+ss:y+2*ss-1) = 0;
                    else
                        % recurse
                        cutCarpet(x + lx*ss, y + ly*ss, ss, cL-1)
                    end
                end
            end
        end
    end
end