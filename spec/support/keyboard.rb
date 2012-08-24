module KeyboardHelper
  def key_down_for(css_selector, *text_strings)
    text_strings.each do |text|
      wait_until { page.has_css?(css_selector) }
      key_down(text)
    end
    wait_until { page.has_no_css?(css_selector) }
  end

  def key_down(text)
    page.evaluate_script "TestHelper.Keyboard.down($('#input'), '#{text}')"
  end
end

include KeyboardHelper