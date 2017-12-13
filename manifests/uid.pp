#
# Provides system-wide defaults for UID settings
#
# @param min
#   The lowest allowed regular user UID for the system
#
# @param max
#   The highest allowed regular user UID for the system
#
#   * If not defined, applications should simply do what makes sense for them
#     internally
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::uid (
  Integer[0]           $min = pick(fact('login_defs.uid_min'), 1000),
  Optional[Integer[1]] $max = fact('login_defs.uid_max')
){
  assert_private()
}
