class ComposerSerializer < ActiveModel::Serializer
  attributes :id, :name, :nationality

  has_many :pieces
end
