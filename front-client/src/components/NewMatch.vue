<template>
  <div>
    <form id='match'>
      <p>
        <label for='game' v-bind:class="{'error-label': errors['game']}">
          Choose game
        </label>
        <select v-model='match.game_id'>
          <option v-for="game in games" :value="game.id">
            {{ game.name }}
          </option>
        </select>
        <p v-if="errors['game']" class="error-label">{{errors['game'].toString()}}</p>
      </p>
      <p>
        <h4>Home team</h4>
        <label for='name' v-bind:class="{'error-label': errors['home_team.name']}">
          name
        </label>
        <input type="text"
               v-model="match.home_team_attributes.name"
               v-bind:class="{'error-field': errors['home_team.name']}"
               name="name">
        </input>
        <p v-if="errors['home_team.name']" class="error-label">
          {{errors['home_team.name'].toString()}}
        </p>
        <p>
          <label for='users' v-bind:class="{'error-label': errors['home_team.team_users']}">
            Add user
          </label>
          <select v-model='userToHomeTeam'>
            <option v-for="user in users" :value="user">
              {{ user.username }}
            </option>
          </select>
          <button type='button' @click='addUserToHomeTeam(userToHomeTeam)'>+</button>
          <p v-if="errors['home_team.team_users']" class="error-label">
            {{errors['home_team.team_users'].toString()}}
          </p>
        </p>
        <p>
          <h5 v-if="usersInHomeTeam.length > 0">Players in home team:</h5>
          <ul>
            <li v-for="user in selectedToHomeTeam">
              {{user.username}}
              <button type='button' @click='removeUserFromHomeTeam(user)'>x</button>
            </li>
          </ul>
        </p>
      </p>
      <p>
        <h4>Invited team</h4>
        <label for='invited-team-name'
               v-bind:class="{'error-label': errors['invited_team.name']}">
          name
        </label>
        <input type="text"
               v-model="match.invited_team_attributes.name"
               v-bind:class="{'error-field': errors['invited_team.name']}"
               name="name">
        </input>
        <p v-if="errors['invited_team.name']" class="error-label">
          {{errors['invited_team.name'].toString()}}
        </p>
        <p>
          <label for='users' v-bind:class="{'error-label': errors['invited_team.team_users']}">
            Add user
          </label>
          <select v-model='userToInvitedTeam'>
            <option v-for="user in users" :value="user">
              {{ user.username }}
            </option>
          </select>
          <button type='button' @click='addUserToInvitedTeam(userToInvitedTeam)'>+</button>
          <p v-if="errors['invited_team.team_users']" class="error-label">
            {{errors['invited_team.team_users'].toString()}}
          </p>
        </p>
        <p>
          <h5 v-if="usersInInvitedTeam.length > 0">Players in invited team:</h5>
          <ul>
            <li v-for="user in selectedToInvitedTeam">
              {{user.username}}
              <button type='button' @click='removeUserFromInvitedTeam(user)'>x</button>
            </li>
          </ul>
        </p>
      <p>
      <button type='button' @click='createMatch()'>Create friendly match</button>
    </form>
  </div>
</template>

<script>
  export default {
    name: 'FriendlyMatchForm',
    data () {
      return {
        userToHomeTeam: {},
        usersInHomeTeam: [],
        userToInvitedTeam: {},
        usersInInvitedTeam: [],
        match: {
          status: 'prepare',
          game_id: '',
          home_team_attributes: {
            name: '',
            user_ids: []
          },
          invited_team_attributes: {
            name: '',
            user_ids: []
          }
        }
      }
    },
    computed: {
      selectedToHomeTeam () {
        return this.usersInHomeTeam
      },
      errors () {
        return this.$store.getters.errors
      },
      selectedToInvitedTeam () {
        return this.usersInInvitedTeam
      },
      users () {
        return this.$store.getters.users
      },
      games () {
        return this.$store.getters.games
      }
    },
    methods: {
      createMatch () {
        this.$store.dispatch('createMatch', this.match)
      },
      addUserToHomeTeam (user) {
        if (!this.match.home_team_attributes.user_ids.includes(user.id)) {
          this.match.home_team_attributes.user_ids.push(user.id)
          this.usersInHomeTeam.push(user)
          this.$store.dispatch('errors', {'home_team.team_users': ''})
        } else {
          this.$store.dispatch('errors', {'home_team.team_users': 'User already in list'})
        }
      },
      removeUserFromHomeTeam (user) {
        var index = this.usersInHomeTeam.findIndex(({id}) => id === user.id)
        this.match.home_team_attributes.user_ids.splice(index, 1)
        this.usersInHomeTeam.splice(index, 1)
      },
      addUserToInvitedTeam (user) {
        if (!this.match.invited_team_attributes.user_ids.includes(user.id)) {
          this.match.invited_team_attributes.user_ids.push(user.id)
          this.usersInInvitedTeam.push(user)
          this.$store.dispatch('errors', {'invited_team.team_users': ''})
        } else {
          this.$store.dispatch('errors', {'invited_team.team_users': 'User already in list'})
        }
      },
      removeUserFromInvitedTeam (user) {
        var index = this.usersInInvitedTeam.findIndex(({id}) => id === user.id)
        this.match.invited_team_attributes.user_ids.splice(index, 1)
        this.usersInInvitedTeam.splice(index, 1)
      }
    }
  }
</script>

<style scoped>
  #match {
    text-align: left;
  }
</style>
