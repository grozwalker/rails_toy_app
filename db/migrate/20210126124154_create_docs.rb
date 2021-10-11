class CreateDocs < ActiveRecord::Migration[6.0]
  def change
    create_table :docs do |t|
      t.text :document_text
    end
  end
end
