module ApplicationHelper
  [
    :text_field,
    :email_field,
    :options,
    :password_field,
    :selecter,
    :text_area
  ].each do |field_type|
    define_method :"labeled_#{field_type}_with_error" do |form, field, options={}|
      builder = LabeledFieldWithError.new(form)
      builder.write(field_type, field, options)
    end
  end

  def labeled_check_box_with_error(form, field, options={})
    builder = LabeledFieldWithError.new(form)
    builder.write(:check_box, field, options.merge(hide_label: true))
  end

  def recaptcha_with_errors(form, options={})
    builder = LabeledFieldWithError.new(form, self)
    builder.write(:recaptcha, :base, {label: :none}.merge(options))
  end

  def value_in_row(name, value)
    content_tag(
      :div,
      content_tag('div', name, :class => 'label') +
      content_tag('div', value, :class => 'value'),
      :class => 'container'
    )
  end

  def text_writer(paragraph)
    paragraph.gsub(/#\?(.*)\?#/) do |json|
      details = JSON.parse(json[2..-3])
      tag = details.delete('tag')
      text = details.delete('text')
      content_tag(tag, text, details)
    end.html_safe
  end

  class LabeledFieldWithError < SimpleDelegator
    def initialize(obj, parent=nil)
      super(obj)
      @parent = parent
    end

    include ActionView::Helpers::TagHelper
    def errors(field)
      error_list = object.errors.get(field)
      return nil if error_list.nil? || error_list.empty?
      ': ' + content_tag(
        :span,
        object.errors.get(field).join(','),
        :class => 'errors'
      )
    end

    def write(field_type, field, options)
      output(field_type, field, options)
    end

    def build_label(field, options)
      label_str = []
      label_str << (options.delete(:label) || field.to_s.titlecase) unless options[:hide_label]
      label_str << errors(field) if errors(field)

      return nil if label_str.empty?
      content_tag(
        :div,
        label(field, label_str.join.html_safe),
        :class => 'label'
      )
    end

    def build_value(field_type, field, options)
      content_tag(
        :div,
        send(field_type, field, options),
        :class => 'value'
      )
    end

    def output(field_type, field, options)
      output = []
      output << build_label(field, options)
      output << build_value(field_type, field, options)

      content_tag(:div,
        output.join.html_safe,
        :class => "container #{field_type}"
      )
    end

    def selecter(field, options)
      items = options.delete(:items) || []
      @delegate_sd_obj.select field, items, options
    end

    def options(field, options)
      # binding.pry
      options[:values].map do |val, text|
        label([field, val].join('_')) do
          radio_button(field, val) +
          content_tag(:span, text, class: 'selector_option')
        end
      end.join("").html_safe
    end

    def text_area(field, options)
      super(field, options.merge(rows: 5))
    end

    def recaptcha(field, options)
      @parent.recaptcha_tags options
    end

    def check_box(field, options)
      label(field) do
        super(
          field,
          {},
          true,
          false
        ) +
        options[:label] || field
      end
    end
  end
end
