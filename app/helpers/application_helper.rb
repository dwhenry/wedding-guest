module ApplicationHelper
  [:text_field, :email_field, :password_field, :selecter, :text_area].each do |field_type|
    define_method :"labeled_#{field_type}_with_error" do |form, field, options={}|
      builder = LabeledFieldWithError.new(form)
      builder.write(field_type, field, options)
    end
  end

  def value_in_row(name, value)
    content_tag(
      :div,
      content_tag('div', name, :class => 'label') +
      content_tag('div', value, :class => 'value'),
      :class => 'container'
    )
  end

  def page_writer(page_name, wedding)
    title = content_tag('div', :class => 'TITLE') do
      page_name.gsub(/_/, ' ').titlecase
    end
    elements = wedding.page_details.for(page_name)
    if elements.presence
      title +
      elements.map do |element|
        content_tag('div', :class => element.formatting_class) do
          element_writer(element)
        end
      end.join.html_safe
    else
      return title +
             content_tag('div', "Under Construction", :class => 'PENDING') +
             content_tag('div', "Please check back soon", :class => 'PENDING')
    end
  end

  def element_writer(element)
    content = []
    if element.image?
      width, height = element.image.get_version_dimensions
      content << content_tag(
        'div',
        '',
        :class => "element_image #{cycle('odd', 'even')}",
        style:  "background-image: url(#{element.image_url}); width: #{width}px; height: #{height}px;"
      )
    end
    element.text.split(/[\r\n]+/).each do |paragraph|
      content << content_tag('p', paragraph)
    end
    content.join.html_safe
  end

  class LabeledFieldWithError < SimpleDelegator
    include ActionView::Helpers::TagHelper
    def errors(field)
      error_list = object.errors.get(field)
      return '' if error_list.nil? || error_list.empty?
      ': ' + content_tag(
        :span,
        object.errors.get(field).join(','),
        :class => 'errors'
      )
    end

    def write(field_type, field, options)
      output(field_type, field, options)
    end

    def output(field_type, field, options)
      label_name = options.delete(:label) || field.to_s.titlecase
      content_tag(:div,
        content_tag(
          :div,
          label(field, (  label_name + errors(field)).html_safe),
          :class => 'label'
        ) + content_tag(
          :div,
          send(field_type, field, options),
          :class => 'value'
        ),
        :class => 'container'
      )
    end

    def selecter(field, options)
      items = options.delete(:items) || []
      @delegate_sd_obj.select field, items, options
    end

    def text_area(field, options)
      super(field, options.merge(rows: 5))
    end
  end
end
