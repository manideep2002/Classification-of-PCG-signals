function expanded_qt = expand_qt(original_qt, old_fs, new_fs, new_length)

original_qt = original_qt(:)';
expanded_qt = zeros(new_length,1);

indeces_of_changes = find(diff(original_qt));

indeces_of_changes = [indeces_of_changes, length(original_qt)];

start_index = 0;
for i = 1:length(indeces_of_changes)
    
    start_index;
    end_index = indeces_of_changes(i);
    
    mid_point = round((end_index - start_index)/2) + start_index;
    
    value_at_mid_point = original_qt(mid_point);
    
    expanded_start_index = round((start_index./old_fs).*new_fs) + 1;
    expanded_end_index = round((end_index./(old_fs)).*new_fs);
    
    if(expanded_end_index > new_length)
        expanded_end_index = new_length;
    end
    
    expanded_qt(expanded_start_index:expanded_end_index) = value_at_mid_point;

    start_index = end_index;
end