module Fields
  def formatted_date(field, options={})
    define_method field do
      read_attribute(field).try(:strftime, options[:format] || '%d %b %Y')
    end
  end

  def prettify_string(field, options={})
    read_transform = options[:read_transform] || ->(val) { val ? val.gsub(/_/, ' ').titlecase : nil }
    write_transform = options[:write_transform] || ->(val) { val ? val.gsub(/ /, '_').downcase : nil }
    define_method field do
      read_transform.call read_attribute(field)
    end
    define_method "#{field}=" do |new_val|
      write_attribute field, write_transform.call(new_val)
    end
  end
end
