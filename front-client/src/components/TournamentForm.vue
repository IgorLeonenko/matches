<template>
  <div>
    <form id='tournament'>
      <p>
        <label for='title' v-bind:class="{'error-label': errors['title']}">Title</label>
        <input type='text'
               v-model='tournament.title' name='title'
               v-bind:class="{'error-field': errors['title']}">
        </input>
        <p v-if="errors['title']" class="error-label">{{errors['title'].toString()}}</p>
      </p>
      <p>
        <label for='description'>Description</label>
        <textarea v-model='tournament.description' name='description'></textarea>
      </p>
      <p>
        <label for='game' v-bind:class="{'error-label': errors['game_id']}">Choose game</label>
        <select v-model='tournament.game_id'>
          <option v-for="game in games" :value="game.id">
            {{ game.name }}
          </option>
        </select>
        <p v-if="errors['game_id']" class="error-label">
          {{errors['game_id'].toString()}}
        </p>
      </p>
      <p>
        <label for='picture'>Image</label>
        <input type="text" v-model='tournament.picture' name="picture"></input>
      </p>
      <p>
        <label for='date' v-bind:class="{'error-label': errors['start_date']}">Start date</label>
        <input type="date"
               v-model='tournament.start_date' name="date"
               v-bind:class="{'error-field': errors['start_date']}">
        </input>
        <p v-if="errors['start_date']" class="error-label">{{errors['start_date'].toString()}}</p>
      </p>
      <p>
        <label for='teams_quantity' v-bind:class="{'error-label': errors['teams_quantity']}">Teams quantity</label>
        <input type="number"
               v-model='tournament.teams_quantity' name="teams_quantity"
               v-bind:class="{'error-field': errors['teams_quantity']}">
        </input>
        <p v-if="errors['teams_quantity']" class="error-label">{{errors['teams_quantity'].toString()}}</p>
      </p>
      <p>
        <label for='players_in_team' v-bind:class="{'error-label': errors['players_in_team']}">Players in team</label>
        <input type="number"
               v-model='tournament.players_in_team' name="players_in_team"
               v-bind:class="{'error-field': errors['players_in_team']}">
        </input>
        <p v-if="errors['players_in_team']" class="error-label">{{errors['players_in_team'].toString()}}</p>
      </p>
      <button type='button' @click='sendTournament()'>{{buttonText}}</button>
    </form>
  </div>
</template>

<script>
  export default {
    name: 'TournamentForm',
    props: {
      buttonText: {
        type: String
      },
      tournament: {
        type: Object
      }
    },
    computed: {
      errors () {
        return this.$store.getters.errors
      },
      games () {
        return this.$store.getters.games
      }
    },
    methods: {
      sendTournament () {
        if (this.$route.name === 'tournamentNew') {
          this.$store.dispatch('addTournament', this.tournament)
        } else if (this.$route.name === 'tournamentUpdate') {
          this.$store.dispatch('updateTournament', this.tournament)
        }
      }
    }
  }
</script>

<style scoped>
  #tournament {
    text-align: left;
  }
</style>
