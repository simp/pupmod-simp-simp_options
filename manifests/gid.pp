#
# Provides system-wide defaults for GID settings
#
# @param min
#   The lowest allowed regular user GID for the system
#
# @param max
#   The highest allowed regular user GID for the system
#
#   * If not defined, applications should simply do what makes sense for them
#     internally
#
# @author SIMP Team - https://simp-project.com
#
class simp_options::gid (
  Integer[0]           $min = 1000,
  Optional[Integer[1]] $max = undef
){
  assert_private()
}
