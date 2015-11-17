function [ new_image ] = assembleBlocks( blocks, k, original_shape, overlap_percent )
%assembleBlocks( blocks, k, original_shape, overlap_percent )
%   Reassemble the image from a list of blocks using alpha blending at
%   overlap

    overlap = int(k*overlap_percent);
    new_image = zeros(original_shape(1)+2*overlap, original_shape(2)+2*overlap);

    n_vert = int(original_shape(1) / k);
    n_horiz = int(original_shape(2) / k);

    % block mask for alpha blending
    block_mask = ones(size(blocks(:,:,1)));
    for i = 1:overlap
        block_mask(:,i) = block_mask(:,i)*(1.0/(overlap+1))*(i);
        block_mask(:,end-(i-1)) = block_mask(:,i);
        block_mask(i,:) = block_mask(i,:)*(1.0/(overlap+1))*(i);
        block_mask(end-(i-1),:) = block_mask(i,:);
    end

    % Iterate through the image and append to 'blocks.'
    for i = 0:n_vert-1
        for j = 0:n_horiz-1
            % Alpha Blending - multiply each block by block mask and add to image
            new_image(i*k+1:((i+1)*k+2*overlap)+1, j*k+1:((j+1)*k+2*overlap)+1) =...
                (blocks(n_horiz*i+j+1).*block_mask)...
                +new_image(i*k+1:((i+1)*k+2*overlap+1), j*k+1:((j+1)*k+2*overlap+1))
        end
    end

    new_image = new_image(overlap:(overlap + original_shape(1)),...
        overlap:(overlap+original_shape(2)));
end
