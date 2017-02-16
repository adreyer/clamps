Puppet::Type.newtype :clamps_file do
  newparam :name
  newparam :ensure do
    desc "ensure value"
  end
  newparam :content do
    desc "file content"
  end
end
