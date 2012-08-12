module Fields
  def formatted_date(field, options={})
    define_method field do
      read_attribute(field).try(:strftime, options[:format] || '%d %b %Y')
    end
  end
end
