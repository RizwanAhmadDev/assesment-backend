require('./bootstrap');

require('alpinejs');

import { createApp } from 'vue';
import EmailForm from './components/EmailForm.vue';

const app = createApp({});
app.component('email-form', EmailForm);
app.mount('#app');
