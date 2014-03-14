class String
  # Don't really like patching string here,
  # but it's fine for now.
  def underscore
    gsub(/::/, '/')
    .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .tr('-', '_')
    .downcase
  end
end
