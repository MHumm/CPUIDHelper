// Dummy project to be able to generate SBOM with dxcomply
program CPUSupportProject;

{$APPTYPE CONSOLE}

uses
  CPUSupport;
  
begin
  WriteLn('Nothing to see! Move on, after pressing enter!');
  WriteLn('This project file is only needed for SBOM generation.');
  ReadLn;
end.
  