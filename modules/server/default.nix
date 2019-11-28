/* GENERAL SERVER CONFIGURATION
 *
 * A server is a computer, that runs headless on a network, performing
 * various tasks, such as providing network services. It has a
 * barebones set of tools installed to interact with it's
 * configuration, and is otherwise pure infrastructure.
 *
 * Root access is generally assumed while rebuilding a server
 * system. Although some machines might have specific tools that come
 * from `base`, these are not important here.
 */

{ ... }:

{
  imports = [
    ./ssh
  ];
}
