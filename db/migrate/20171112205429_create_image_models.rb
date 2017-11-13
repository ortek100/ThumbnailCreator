class CreateImageModels < ActiveRecord::Migration[5.1]
  def change
    create_table :image_models do |t|

      t.timestamps
    end
  end
end
