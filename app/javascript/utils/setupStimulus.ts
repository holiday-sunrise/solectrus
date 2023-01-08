import { Application } from '@hotwired/stimulus';
import { registerControllers } from 'stimulus-vite-helpers';
import * as Turbo from '@hotwired/turbo';

// Start Stimulus application
const application = Application.start();

// Configure Stimulus development experience
application.debug = false; // process.env.NODE_ENV === 'development';

// Load and register global controllers
registerControllers(
  application,
  import.meta.glob('../controllers/*_controller.{js,ts}', { eager: true }),
);

// Load and register view_components controllers
registerControllers(
  application,
  import.meta.glob('../../components/**/*_controller.{js,ts}', { eager: true }),
);

import TurboMorph from 'turbo-morph';
TurboMorph.initialize(Turbo.StreamActions);