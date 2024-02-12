// @ts-ignore
const { Typed } = window;

const typed2 = new Typed('#strike', {
  strings: [
    'hello',
    'hi',
    'hey',
    'ping',
    'اَلسَّلَامُ عَلَيْكُمْ only',
    "g'day",
    'bonjour',
    'yo',
    'hola',
    'morning!',
    'hallo',
    'ciao',
    '&#128075;',
    'namaste',
    'hoi',
    "m'athchomaroon",
    'hiya',
    'you got a sec?',
    'greetings!',
    'aloha',
    'buenos dias',
    'nuqneH',
    'heya',
    'olÃ ',
    'apipoulaÃ¯',
    'j0',
    'howdy',
    'yooooooooooo!',
    'you there?',
    'fraeslis',
    'sul sul',
    'quick question...',
    'achuta',
  ],
  typeSpeed: 80,
  backSpeed: 60,
  smartBackspace: false,
  loop: true,
  shuffle: false,
  backDelay: 2000,
  startDelay: 3000,
});

// force the start of cursor animation while the `startDelay` is ticking
if (typed2.cursor != null) {
  // can't use `toggleBlinking(true)` here, as it has some extra checks
  // whether animation has started...which defeats the purpose
  typed2.cursor.classList.add('typed-cursor--blink');
}