module RestrictRefineryToRefineryUsers

  def restrict_refinery_to_refinery_users
    return unless !current_user.has_role?(:refinery) #current_user.try(:roles).try(:empty?) is another possibility
    redirect_to '/' #this user is not a refinery user because they have no refinery roles.
    return false
  end

end
