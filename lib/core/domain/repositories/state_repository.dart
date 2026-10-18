/// An interface for state repositories.
///
/// State repositories are responsible for managing the state of an application.
/// This includes loading data, and resetting the state.
///
/// The [resetState] method is used to reset the state of the repository.
/// This is typically used when the user wants to reset the state of the
/// application.
///
/// The [loadData] method is used to load data from the repository. This
/// can be used to load data when the application starts, or when the user
/// wants to refresh the data.
///
/// The [loadData] method takes an optional [refresh] parameter, which is
/// a boolean that indicates whether the method should load data from the
/// repository, or whether it should use the existing data.
///
/// If [refresh] is `true`, the method will load data from the repository.
/// If [refresh] is `false`, the method will use the existing data.
/// If [refresh] is `null`, the method will use the existing data, unless
/// the existing data is `null`, in which case the method will load data
/// from the repository.
abstract interface class StateRepository {
  void resetState();

  Future<void> loadData({bool? refresh});
}
