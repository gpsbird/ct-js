sound-editor.panel.view
    .modal
        b {voc.name}
        br
        input.wide(type="text" value="{sound.name}" onchange="{wire('this.sound.name')}")
        br
        br
        label.file
            .button.inline
                i.icon.icon-plus
                span {voc.import}
            input(type="file" ref="inputsound" accept=".mp3,.ogg,.wav" onchange="{changeSoundFile}")
        audio(
            if="{sound && sound.origname}" 
            ref="audio" controls loop 
            src="file://{sessionStorage.projdir + '/snd/' + sound.origname + '?' + sound.lastmod}"
            onplay="{notifyPlayerPlays}"
        )
        br
        br
        button.wide(onclick="{soundSave}")
            i.icon.icon-confirm
            span {voc.save}
    script.
        const path = require('path');
        this.namespace = 'soundview';
        this.mixin(window.riotVoc);
        this.mixin(window.riotWired);
        this.playing = false;
        this.sound = this.opts.sound;
        this.notifyPlayerPlays = e => {
            this.playing = true;
        };
        this.soundSave = e => {
            if (this.playing) {
                this.togglePlay();
            }
            this.parent.editing = false;
            this.parent.update();
        };
        this.togglePlay = function () {
            if (this.playing) {
                this.playing = false;
                this.refs.audio.pause();
            } else {
                this.playing = true;
                this.refs.audio.play();
            }
        };
        this.changeSoundFile = () => {
            var val = this.refs.inputsound.value;
            megacopy(val, sessionStorage.projdir + '/snd/s' + this.sound.uid + path.extname(val), e => {
                if (e) {
                    console.log(e);
                    alertify.error(e);
                } else {
                    if (!this.sound.lastmod) {
                        this.sound.name = path.basename(val, path.extname(val));
                    }
                    this.sound.origname = 's' + this.sound.uid + path.extname(val);
                    this.sound.lastmod = +(new Date());
                    this.update();
                }
            });
            this.refs.inputsound.value = '';
        };