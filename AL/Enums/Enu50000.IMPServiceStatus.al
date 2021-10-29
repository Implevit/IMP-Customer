enum 50000 IMPServiceStatus
{
    Extensible = true;

    value(0; "None") { Caption = ' '; }
    value(10; Running) { Caption = 'running'; }
    value(20; Starting) { Caption = 'starting'; }
    value(30; ToStart) { Caption = 'to start'; }
    value(40; Stopped) { Caption = 'stopped'; }
    value(50; Stoping) { Caption = 'stoping'; }
    value(60; ToStop) { Caption = 'to stop'; }
    value(70; Restarting) { Caption = 'restarting'; }
    value(80; ToRestart) { Caption = 'to restart'; }
    value(90; ToCreate) { Caption = 'to create'; }
    value(100; ToRemove) { Caption = 'to remove'; }
    value(110; Removing) { Caption = 'removing'; }
}