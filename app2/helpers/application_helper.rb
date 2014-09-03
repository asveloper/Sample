module ApplicationHelper
  def sortable(column, title = nil, sphinx = nil ,fields = nil)
    title,css_class,direction = set_initial_values(column, title)
    if sphinx
      if sphinx == 'contact'
        link_to title, {:sort => column, :direction => direction , :search => fields[0], :category => fields[1]}, {:class => css_class}
      elsif sphinx == 'employee'
        link_to title, {:sort => column, :direction => direction , :search => fields[0], :designation => fields[1], :active => fields[2]}, {:class => css_class}
      elsif sphinx == 'interview'
        link_to title, {:sort => column, :direction => direction , :search => fields[0], :institution => fields[1], :position => fields[2], :status => fields[3]}, {:class => css_class}
      else
        link_to title, {:sort => column, :direction => direction}, {:class => css_class}
      end
    else
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    end
  end

  def set_initial_values(column, title)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    return title,css_class,direction
  end

  def sortable_SR(column, title = nil,month=nil,year=nil)
    title ||= column.titleize
    css_class = column == sort_column_SR ? "current #{sort_direction}" : nil
    direction = column == sort_column_SR && sort_direction == "asc" ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction,:month =>month, :year => year}, {:class => css_class}
  end
end
