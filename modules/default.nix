{...}: {
  homeManagerModules = {
    minimal = import ./common;
    desktop = import ./desktop;
    server = import ./server;
    work = import ./work;
  };
}
