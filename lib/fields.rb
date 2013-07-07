module Fields
  def formatted_date(field, options={})
    define_method field do
      read_attribute(field).try(:strftime, options[:format] || '%d %b %Y')
    end
  end

  def prettify_string(field, options={})
    read_transform = options[:read_transform] || Transforms.read_transform

    write_transform = options[:write_transform] || Transforms.write_transform

    define_method "raw_#{field}" do
      read_attribute(field)
    end
    define_method field do
      read_transform.call read_attribute(field)
    end
    define_method "#{field}=" do |new_val|
      write_attribute field, write_transform.call(new_val)
    end
  end

  module Transforms
    def read_transform
      ->(val) {
        if val
          val.gsub(/_/, ' ').titlecase.gsub(/\|.+\|/) do |upcased|
            upcased[1..-2].upcase
          end
        end
      }
    end

    def write_transform
      ->(val) {
        if val
          val.split(' ').map do |partial|
            if partial =~ /^[A-Z]*$/
              "|#{partial}|"
            else
              partial
            end
          end.join('_').downcase
        end
      }
    end

    extend self
  end
end
