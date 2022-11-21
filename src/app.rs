use crossterm::event;
use crossterm::event::{Event, KeyCode};
use std::io;
use tui::{backend::Backend, Terminal};
use crate::ui;

/// App holds the state of the application
pub struct App {
    /// Current value of the input box
    pub input: String,
    /// Current input mode
    pub input_mode: ui::InputMode,
    /// History of recorded messages
    pub messages: Vec<String>,
}

impl Default for App {
    fn default() -> App {
        App {
            input: String::new(),
            input_mode: ui::InputMode::Normal,
            messages: Vec::new(),
        }
    }
}

pub fn run<B: Backend>(terminal: &mut Terminal<B>, mut app: App) -> io::Result<()> {
    loop {
        terminal.draw(|f| ui::draw(f, &app))?;

        if let Event::Key(key) = event::read()? {
            match app.input_mode {
                ui::InputMode::Normal => match key.code {
                    KeyCode::Char('e') => {
                        app.input_mode = ui::InputMode::Editing;
                    }
                    KeyCode::Char('q') => {
                        return Ok(());
                    }
                    _ => {}
                },
                ui::InputMode::Editing => match key.code {
                    KeyCode::Enter => {
                        app.messages.push(app.input.drain(..).collect());
                    }
                    KeyCode::Char(c) => {
                        app.input.push(c);
                    }
                    KeyCode::Backspace => {
                        app.input.pop();
                    }
                    KeyCode::Esc => {
                        app.input_mode = ui::InputMode::Normal;
                    }
                    _ => {}
                },
            }
        }
    }
}
