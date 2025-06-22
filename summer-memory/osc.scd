(

~tdAddrs = Dictionary.new;

~tdAddrs['1'] = NetAddr("127.0.0.1", 57130);
~tdAddrs['2'] = NetAddr("127.0.0.1", 57130);
~tdAddrs['3'] = NetAddr("127.0.0.1", 57132);

~instInfo = Dictionary.new;
~instInfo['1'] = Dictionary.new;

OSCdef(\tdSend, {
    arg msg;

    var dict, addr, id, info;
    dict = Dictionary.new;

    msg = msg.drop(1);
    msg = msg.clump(2);

    msg.do({
        arg pair;
        if (pair.size == 2, {
            dict.put(pair[0], pair[1]);
        }, {
            "Warning: Incomplete pair found: %".format(pair).warn;
        });
    });

    id = dict['_id_'];
    info = ~instInfo[id];
    addr = ~tdAddrs[id];
    if (id == '1', {
        // copy the dict, check if this message is the same as the last (minus note)
        var thisMessage = dict.copy;
        thisMessage.put(\note, nil);
        if (info[\last] != thisMessage, {
            // if it's not, ping TD
            addr.sendMsg(\imagePing);
        });
        info[\last] = thisMessage;
    });
    if (id == '2', {
        addr.sendMsg(\bloomPing);
    });
    if (id == '3', {
        addr.sendMsg(\displacement, dict[\gain]);
    });
}, '/dirt/play');

)

OSCdef(\tdSend).free;
