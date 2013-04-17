class AddParamNameToWedding < ActiveRecord::Migration
  def change
    add_column :weddings, :param_name, :string
    Wedding.all.each do |wedding|
      wedding.param_name = wedding.name.gsub(/ /, '_')
      wedding.save!
    end
  end
end
