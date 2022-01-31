class CreateBigCommerceHeadquarterTemps < ActiveRecord::Migration[5.2]
  def change
    create_table :big_commerce_headquarter_temps do |t|
      t.timestamps :date
      t.integer :temp

      t.timestamps
    end
  end
end
